CREATE OR REPLACE PACKAGE BODY DBADMINDATA.PKG_EMAIL
AS

PROCEDURE SEND_MAIL(p_to			IN VARCHAR2,
					p_from			IN VARCHAR2,
					p_subject		IN VARCHAR2,
					p_msg			IN clob,
					p_charset		IN varchar2 DEFAULT vcharset,
					p_content_type	IN VARCHAR2 DEFAULT vcontent_type,
					p_smtp_host		IN VARCHAR2 DEFAULT vsmtp_host,
					p_smtp_port		IN NUMBER DEFAULT nsmtp_port,
					p_attach		IN attachments DEFAULT NULL)
IS
	l_mail_conn		UTL_SMTP.connection;
	l_boundary		VARCHAR2(50) := '----=*#abc1234321cba#*=';
	L_OFFSET		NUMBER;
	L_AMMOUNT		NUMBER;
	l_step			PLS_INTEGER := 57;
BEGIN
	l_mail_conn := UTL_SMTP.open_connection(p_smtp_host, p_smtp_port);
	UTL_SMTP.helo(l_mail_conn, p_smtp_host);
	UTL_SMTP.mail(l_mail_conn, p_from);
 
	FOR x IN (SELECT LEVEL AS id, REGEXP_SUBSTR(p_to, '[^,]+', 1, LEVEL) AS TO_EMAIL_NAME FROM DUAL
				CONNECT BY REGEXP_SUBSTR(p_to, '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
		utl_smtp.Rcpt(l_mail_conn,x.TO_EMAIL_NAME);
	END LOOP;

	--UTL_SMTP.rcpt(l_mail_conn, p_to);

	UTL_SMTP.open_data(l_mail_conn);

	UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
	UTL_SMTP.write_data(l_mail_conn, 'To: ' || p_to || UTL_TCP.crlf);
	UTL_SMTP.write_data(l_mail_conn, 'From: ' || p_from || UTL_TCP.crlf);
	UTL_SMTP.write_raw_data(l_mail_conn, utl_raw.cast_to_raw('Subject: ' || p_subject || UTL_TCP.crlf));
	--UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || p_subject || UTL_TCP.crlf);
	UTL_SMTP.write_data(l_mail_conn, 'Reply-To: ' || p_from || UTL_TCP.crlf);
	UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
	UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
  
    UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'Content-Type: '||p_content_type||'; charset="'||p_charset||'"' || UTL_TCP.crlf || UTL_TCP.crlf);
	
	L_OFFSET  := 1;
	L_AMMOUNT := 4000;

   	IF p_msg IS NOT NULL THEN
		WHILE L_OFFSET < DBMS_LOB.GETLENGTH(p_msg)
		LOOP
			--UTL_SMTP.WRITE_DATA(l_mail_conn, DBMS_LOB.SUBSTR(p_msg,L_AMMOUNT,L_OFFSET));
			utl_smtp.write_raw_data(l_mail_conn, utl_raw.cast_to_raw(DBMS_LOB.SUBSTR(p_msg,L_AMMOUNT,L_OFFSET)));
			L_OFFSET  := L_OFFSET + L_AMMOUNT ;
			L_AMMOUNT := LEAST(L_AMMOUNT,DBMS_LOB.GETLENGTH(p_msg) - L_AMMOUNT);
		END LOOP;
		UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
	END IF;

	IF p_attach IS NOT NULL THEN
		FOR i IN p_attach.FIRST .. p_attach.LAST
		LOOP
		    
			UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
			UTL_SMTP.write_data(l_mail_conn, 'Content-Type: ' || p_attach(i).data_type || '; name="' || p_attach(i).attach_name || '"' || UTL_TCP.crlf);
			UTL_SMTP.write_data(l_mail_conn, 'Content-Transfer-Encoding: base64' || UTL_TCP.crlf);
			UTL_SMTP.write_data(l_mail_conn, 'Content-Disposition: attachment; filename="' || p_attach(i).attach_name || '"' || UTL_TCP.crlf || UTL_TCP.crlf);
			
			FOR j IN 0 .. TRUNC((DBMS_LOB.getlength(p_attach(i).attach_content) - 1 )/l_step) LOOP
      			UTL_SMTP.write_data(l_mail_conn, UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(DBMS_LOB.substr(p_attach(i).attach_content, l_step, j * l_step + 1))) || UTL_TCP.crlf);
    		END LOOP;
		    NULL;
	    END LOOP;
	END IF;

	UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
	UTL_SMTP.close_data(l_mail_conn);
	UTL_SMTP.quit(l_mail_conn);
END SEND_MAIL;

END PKG_EMAIL;