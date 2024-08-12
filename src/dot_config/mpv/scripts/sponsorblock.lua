-- sponsorblock_minimal.lua
--
-- This script skips sponsored segments of YouTube videos
-- using data from https://github.com/ajayyy/SponsorBlock

local opt = require 'mp.options'

local options = {
	server = "https://sponsor.ajay.app/api/skipSegments",

	-- Categories to fetch and skip
	categories = '"sponsor"'
}

opt.read_options(options)

function getranges()
	local luacurl_available, cURL = pcall(require,'cURL')

	local cstr = ("categories=[%s]"):format(options.categories)
	local vstr = ("videoID=%s"):format(youtube_id)

	if not(luacurl_available) then -- if Lua-cURL is not available on this system
		local curl_cmd = {
			"curl",
			"-L",
			"-s",
			"-G",
			"-d", cstr,
			"-d", vstr,
			options.server
		}
		local sponsors = mp.command_native{
			name = "subprocess",
			capture_stdout = true,
			playback_only = false,
			args = curl_cmd
		}
		res = sponsors.stdout
	else -- otherwise use Lua-cURL (binding to libcurl)
		local API = ("%s?%s&%s"):format(options.server, cstr, vstr)
		local buf={}
		local c = cURL.easy_init()
		c:setopt_followlocation(1)
		c:setopt_url(API)
		c:setopt_writefunction(function(chunk) table.insert(buf,chunk); return true; end)
		c:perform()
		res = table.concat(buf)
	end

	if string.match(res,"%[(.-)%]") then
		ranges = {}
		for i in string.gmatch(string.sub(res,2,-2),"%[(.-)%]") do
			k,v = string.match(i,"(%d+.?%d*),(%d+.?%d*)")
			ranges[k] = v
		end
	end
	return
end

function skip_ads(name,pos)
	if pos ~= nil then
		for k,v in pairs(ranges) do
			k = tonumber(k)
			v = tonumber(v)
			if k <= pos and v > pos then
				--this message may sometimes be wrong
				--it only seems to be a visual thing though
				mp.osd_message(("[sponsorblock] skipping forward %ds"):format(math.floor(v-mp.get_property("time-pos"))))
				--need to do the +0.01 otherwise mpv will start spamming skip sometimes
				--example: https://www.youtube.com/watch?v=4ypMJzeNooo
				mp.set_property("time-pos",v+0.01)
				return
			end
		end
	end
	return
end

function file_loaded()
	local video_path = mp.get_property("path", "")
	local video_referer = string.match(mp.get_property("http-header-fields", ""), "Referer:([^,]+)") or ""

	local urls = {
		"ytdl://youtu%.be/([%w-_]+).*",
		"ytdl://w?w?w?%.?youtube%.com/v/([%w-_]+).*",
		"https?://youtu%.be/([%w-_]+).*",
		"https?://w?w?w?%.?youtube%.com/v/([%w-_]+).*",
		"/watch.*[?&]v=([%w-_]+).*",
		"/embed/([%w-_]+).*",
		"^ytdl://([%w-_]+)$",
		"-([%w-_]+)%."
	}
	youtube_id = nil
	local purl = mp.get_property("metadata/by-key/PURL", "")
	for i,url in ipairs(urls) do
		youtube_id = youtube_id or string.match(video_path, url) or string.match(video_referer, url) or string.match(purl, url)
	end

	if not youtube_id or string.len(youtube_id) < 11 then return end
	youtube_id = string.sub(youtube_id, 1, 11)

	getranges()
	if ranges then
		ON = true
		mp.add_key_binding("b","sponsorblock",toggle)
		mp.observe_property("time-pos", "native", skip_ads)
	end
	return
end

function end_file()
	if not ON then return end
	mp.unobserve_property(skip_ads)
	ranges = nil
	ON = false
end

function toggle()
	if ON then
		mp.unobserve_property(skip_ads)
		mp.osd_message("[sponsorblock] off")
		ON = false
		return
	end
	mp.observe_property("time-pos", "native", skip_ads)
	mp.osd_message("[sponsorblock] on")
	ON = true
	return
end

mp.register_event("file-loaded", file_loaded)
mp.register_event("end-file", end_file)
