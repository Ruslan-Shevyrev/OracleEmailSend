# Send-Email-CLOB

Sending an email with the **CLOB** Message Body.

```
PROCEDURE SEND_MAIL(p_to            IN VARCHAR2,
                    p_from          IN VARCHAR2,
                    p_subject       IN VARCHAR2,
                    p_msg           IN clob,
                    p_charset       IN varchar2 DEFAULT vcharset,
                    p_content_type  IN VARCHAR2 DEFAULT vcontent_type,
                    p_smtp_host     IN VARCHAR2 DEFAULT vsmtp_host,
                    p_smtp_port     IN NUMBER DEFAULT nsmtp_port,
                    p_attach        IN attachments DEFAULT NULL);
```

:one: **p_to** - myltiple emails separate by ***comma*** **(,)**

**Example:**
```
test1@mail.com,test2@mail.com
```

:two: **p_message** - you need to make sure that every 1000 characters you add **chr(10)||chr(13)** or **UTL_TCP.crlf**\
:warning: It's very important if you use multiple language in your ***message body***.

:three: **p_charset** - default **'utf-8'**

:four: **p_content_type** - default **'text/html'**

:five: **p_attach** - Nested Table:

```
TYPE attach_info IS RECORD (attach_name     VARCHAR2(40),
                            data_type       VARCHAR2(40) DEFAULT 'text/plain',
                            attach_content  BLOB);
```

**Example:**
```
DECLARE
    attachments PKG_EMAIL.attachments:=PKG_EMAIL.attachments();
BEGIN
    attachments.extend(1);
    attachments(attachments.LAST).attach_name:='Test1.txt';
    attachments(attachments.LAST).attach_content:=/*PKG_TOOL.clob2blob('Test Message 1'); -- convert to clob to blob*/
    attachments.extend(1);
    attachments(attachments.LAST).attach_name:='Test2.txt';
    attachments(attachments.LAST).attach_content:=/*PKG_TOOL.clob2blob('Test Message 2'); -- convert to clob to blob*/ 

    DBADMINDATA.PKG_EMAIL.SEND_MAIL(p_to        =>'test_to@test.com',
                                    p_from      =>'test_from@test.com',
                                    p_subject   =>'test',
                                    p_msg       =>'test',
                                    p_attach    =>attachments);
END;
```

<table>
	<tr>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logo_mini.gif" title="logo"></td>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logoRS_FULL.png" title="RuslanShevyrev"></td>
	</tr>
</table>