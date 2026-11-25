return {
    s({ trig = "dbg", desc = "debug print" },
        fmt('print(f"DEBUG: {{( {} ) = }}")',
            { i(1, "expr") })),
    s({ trig = "str", desc = "triple-quote string" },
        fmt([[
            """
            {}
            """
        ]],
            { i(1) })),
}
