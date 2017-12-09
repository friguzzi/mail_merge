/*  Author:        Fabrizio Rituzzi
    E-mail:        fabrizio.riguzzi@unife.it
    WWW:           http://mcs.unife.it/~friguzzi/
    Copyright (C): 2017, Fabrizio Riguzzi

    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in
       the documentation and/or other materials provided with the
       distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/

:- module(mail_merge,
  [mail_merge/3]).
  
:- use_module(library(smtp)).
:- use_module(library(settings)).

/** <module> Perform Mail Merge

This module provides a  simple  means  to  perform mail merge from a Prolog
application: send personalized email message to a list of recipients.
  Here is a simple example:

==
mail_merge('Hello ~s how are you?',[['gianni@abc.com','Gianni'],
  ['stefi@cde.com','Stefi']],
  [subject('Hello'),from('Fabrizo'),auth(<google_user>-<google_password>)]).
==
*/

%!  mail_merge(+Message:atom_or_string,,+Addresses:list,+Options:list)
%
%   Perform mail merge using SMTP. 
%   Message is a format string as in format/2, Addresses is a list of lists, each sublist is of the for
%   [To|Fields] where To is the recipient of the message and Fields contain the values to replace placeholders in Message. 
%   Message and Fields are passed to format/2 to produce the message. Options are passed to smtp_send_mail/3 from package
%   smtp, they are:
%
%     * smtp(+Host)
%       the name or ip address for smtp host, eg. swi-prolog.org
%     * from(+FromAddress)
%       atomic identifies sender address.  Provides the default
%       for header(from(From)).
%     * date(+Date)
%       Set the date header.  Default is to use the current time.
%     * subject(+Subject)
%       atomic: text for 'Subject:' email header
%     * auth(User-Password)
%       authentication credentials, as atoms or strings.
%     * auth_method(+PlainOrLoginOrNone)
%       type of authentication. Default is =default=, alternatives
%       are =plain= and =login=
%     * security(Security)
%       one of: `none`, `ssl`, `tls`, `starttls`
%     * content_type(+ContentType)
%       sets =|Content-Type|= header
%     * mailed_by(By)
%       add X-Mailer: SWI-Prolog <version>, pack(smtp) to header
%       iff By == true
%     * header(Name(Val))
%       add HName: Val to headers. HName is Name if Name's first
%       letter is a capital, and it is Name after capitalising its
%       first letter otherwise. For instance header(from('My name,
%       me@server.org')) adds header "From: My name, my@server.org"
%       and header('FOO'(bar)) adds "FOO: bar"
%
%   Defaults are provided by settings associated to this module. host, port, security and auth_method are 
%   set by defualt to the values needed by gmail. If you use your gmail account you should just provide 
%   the option auth(<google_user>-<google_password>)
%   You should also make sure that your google account has the option "Allow less secure apps" set to on.
%   You can find the option in your account page under Apps with account access.

mail_merge(Message,Addresses,Options):-
  maplist(send_mail(Message,Options),Addresses).

send_mail(Message,Options,[To|Fields]):-
  smtp_send_mail(To,
    send_message(Message,Fields),
    Options).

send_message(Message,Fields,Out) :-
    format(Out, Message,Fields).


:- set_setting_default(smtp:host,        'smtp.gmail.com').
:- set_setting_default(smtp:port,        465).
:- set_setting_default(smtp:security,    ssl).
:- set_setting_default(smtp:auth_method, login).