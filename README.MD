# OracleEmailSend

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

**p_to** - myltiple emails separate by ***comma*** **(,)**

**Example:**
```
test1@mail.com,test2@mail.com
```

<table>
	<tr>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logo_mini.gif" title="logo"></td>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logoRS_FULL.png" title="RuslanShevyrev"></td>
	</tr>
</table>