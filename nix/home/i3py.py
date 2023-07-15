from i3pystatus import Status
#from i3pystatus.mail import thunderbird


status = Status()

status.register("clock", format=" %a %F  %T",)

status.register("battery", format="{glyph} {percentage_design:.0f}%", alert=True, glyphs=["", "", "", "", ""])

status.register("dpms", format="", format_disabled="", color_disabled="#A52A2A")

#status.register("pulseaudio", format=" {volume}", multi_colors=True)

status.register("load", format="{avg5} {avg1}")

status.register("cpu_usage")

#status.register("temp")

status.register("network", interface="wlp4s0",
                format_up="{essid}  {bytes_sent} MiB/s  {bytes_recv} MiB/s",
                format_down=" down",
                divisor=1024**2, recv_limit=250000, sent_limit=40000)

status.register("network", interface="enp5s0f3u1u1",
                format_up="  {bytes_sent} MiB/s  {bytes_recv} MiB/s",
                format_down=" down",
                divisor=1024**2, recv_limit=250000, sent_limit=40000)


status.register("disk", format=" {avail} GiB", path="/")

#status.register("mail", backends=[thunderbird.Thunderbird()])

status.run()
