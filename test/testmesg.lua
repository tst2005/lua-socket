mesgt = {
    headers = {
       to = "D Burgess <db@werx4.com>",
       subject = "Looking good! (please check headers)"
    },
    body = {
        preamble = "Some attatched stuff",
        [1] = {
            body = mime.eol(0, "Testing stuffing.\n.\nGot you.\n.Hehehe.\n")
        },
        [2] = {
            headers = {
                ["content-type"] = 'application/octet-stream; name="luasocket"',
                ["content-disposition"] = 'attachment; filename="luasocket"',
                ["content-transfer-encoding"] = "BASE64"
            },
            body = ltn12.source.chain(
                ltn12.source.file(io.open("luasocket", "rb")),
                ltn12.filter.chain(
                    mime.encode("base64"),
                    mime.wrap()
                )
            )
        },
        [3] = {
            headers = {
                ["content-type"] = 'text/plain; name="testmesg.lua"',
                ["content-disposition"] = 'attachment; filename="testmesg.lua"',
                ["content-transfer-encoding"] = "QUOTED-PRINTABLE"
            },
            body = ltn12.source.chain(
                ltn12.source.file(io.open("testmesg.lua", "rb")),
                ltn12.filter.chain(
                    mime.normalize(),
                    mime.encode("quoted-printable"),
                    mime.wrap("quoted-printable")
                )
            )
        },
        epilogue = "Done attaching stuff",
    }
}

-- sink = ltn12.sink.file(io.stdout)
-- source = ltn12.source.chain(socket.smtp.message(mesgt), socket.smtp.stuff())
-- ltn12.pump.all(source, sink)

print(socket.smtp.send {
    rcpt = "<diego@cs.princeton.edu>",
    from = "<diego@cs.princeton.edu>",
    source = socket.smtp.message(mesgt),
    server = "mail.cs.princeton.edu"
})
