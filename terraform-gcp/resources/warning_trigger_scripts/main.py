import smtplib, ssl
def sendWarningMail():
    port = 465  # For SSL
    smtp_server = "smtp.gmail.com"
    sender_email = "ltorrusio@itba.edu.ar"  # Enter your address
    receiver_email = "lucia.torrusio@gmail.com"  # Enter receiver address
    password ="Enero2020Bariloche"
    message = """\
    Subject: Hi there

    This message is sent from Python."""

    context = ssl.create_default_context()
    with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message)