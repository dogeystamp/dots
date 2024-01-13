/* See LICENSE file for copyright and license details. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"

void
die(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);

	if (fmt[0] && fmt[strlen(fmt)-1] == ':') {
		fputc(' ', stderr);
		perror(NULL);
	} else {
		fputc('\n', stderr);
	}

	exit(1);
}

/*
 * Splits a string into segments according to a separator. A '\0' is written to
 * the end of every segment. The beginning of every segment is written to
 * 'pbegin'. Only the first 'maxcount' segments will be written if
 * maxcount > 0. Inspired by python's split.
 *
 * Used exclusively by fakesignal() to split arguments.
 */
size_t
split(char *s, const char* sep, char **pbegin, size_t maxcount) {

	char *p, *q;
	const size_t seplen = strlen(sep);
	size_t count = 0;

	maxcount = maxcount == 0 ? (size_t)-1 : maxcount;
	p = s;
	while ((q = strstr(p, sep)) != NULL && count < maxcount) {
		pbegin[count] = p;
		*q = '\0';
		p = q + seplen;
		count++;
	}
	if (count < maxcount) {
		pbegin[count] = p;
		count++;
	}
	return count;
}

void *
ecalloc(size_t nmemb, size_t size)
{
	void *p;

	if (!(p = calloc(nmemb, size)))
		die("calloc:");
	return p;
}
