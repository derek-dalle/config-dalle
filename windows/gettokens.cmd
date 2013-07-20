@echo off

REM Get Kerberos tokens.
kinit %USERNAME%@UMICH.EDU

REM Get AFS tokens.
aklog
