from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.application import MIMEApplication
import smtplib
import ssl

from datetime import datetime
def sendWarningMail(arg1, arg2):

    smtp_server = "smtp.gmail.com"
    port = 587  # For starttls

    sender_email = "cloud.innocenceproject@gmail.com" # TODO: replace with your email address
    receiver_email = ["lucia.torrusio@gmail.com", "ltorrusio@itba.edu.ar"] # TODO: replace with your recipients
    password = 'cjckfwkgeustgqxn'  # TODO: replace with your 16-digit-character password 

    # assuming these two values are from your analysis
    score = 0.86

    # Current date time in local system
    today_date = datetime.now()

    # initialise message instance
    msg = MIMEMultipart()
    msg["Subject"] = "New object in bucket on date {}".format(today_date)
    msg["From"] = sender_email
    msg['To'] = ", ".join(receiver_email)

    # ## Plain text
    # text = """\
    # This line is to demonstrate sending plain text."""

    # body_text = MIMEText(text, 'plain')  # 
    # msg.attach(body_text)  # attaching the text body into msg

    html = """\
    <html>
    <body>
        <p>Hi,<br>
        <br>
        This is to inform a new event<br><br> date: {},<br><br> bucket:  {},<br><br> added object: {} <br><br>
        Thank you. <br>
        </p>
    </body>
    </html>
    """

    body_html = MIMEText(html.format(today_date, arg1, arg2), 'html')  # parse values into html text
    msg.attach(body_html)  # attaching the text body into msg

    ## Image
    # img_name = 'test.png' # TODO: replace your image filepath/name
    # with open(img_name, 'rb') as fp:
    #     img = MIMEImage(fp.read())
    #     img.add_header('Content-Disposition', 'attachment', filename=img_name)
    #     msg.attach(img)

    ## Attachments in general
    ## Replace filename to your attachments. Tested and works for png, jpeg, txt, pptx, csv
    # filename = 'test.csv' # TODO: replace your attachment filepath/name
    # with open(filename, 'rb') as fp:
    #     attachment = MIMEApplication(fp.read())
    #     attachment.add_header('Content-Disposition', 'attachment', filename=filename)
    #     msg.attach(attachment)

    context = ssl.create_default_context()
    # Try to log in to server and send email
    try:
        server = smtplib.SMTP(smtp_server, port)
        server.ehlo()  # check connection
        server.starttls(context=context)  # Secure the connection
        server.ehlo()  # check connection
        server.login(sender_email, password)

        # Send email here
        server.sendmail(sender_email, receiver_email, msg.as_string())

    except Exception as e:
        # Print any error messages to stdout
        print(e)
    finally:
        server.quit()