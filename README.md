# Mail Merge
Library for performing mail merge
https://en.wikipedia.org/wiki/Mail_merge


Installation (from within SWI-Prolog):

  ```
  ?- pack_install(mail_merge).
  ```

Uses by default the gmail smtp server. Messages are composed using format/2 with
the message body as the format string and the fields as arguments. Option can provided
as in the smtp pack