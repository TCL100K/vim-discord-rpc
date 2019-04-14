" Discord RPC implementation for Vim
" Last Change: 	2019 Apr 14
" Maintainer: 	TCL100K <tcl100kb@gmail.com>
" License: 			This file is placed in public domain.

if !has('python3')
	echo "Error: this vim version doesnt have python3 module."
	finish
endif

if exists("g:vim_rpc")
	finish
endif

let g:vim_rpc = 1

function! vimrpc#version()
	return '0.1.0'
endfunction

function! vimrpc#run()
python3 << endPython

import vim

from os import getpid
from threading import Thread
from calendar import timegm
from time import sleep, gmtime
from pypresence import Presence

client_id = '566774665125560352'

RPC = Presence(client_id)
RPC.connect()

startTime = timegm(gmtime())
runThread = True

def getFilename(path):
	spath = path.split("/")
	return spath[len(spath) - 1]

def getCurrentBufferName():
	return getFilename(vim.current.buffer.name)

def getCwd():
	cwd = vim.eval("getcwd()")

def updateRPC():
	while runThread:
		project = "Project: " + getCwd()
		RPC.update(state=project, details=getCurrentBufferName(), start=startTime)
		sleep(15)

t = Thread(target=updateRPC)
t.start()

endPython
endfunction

function! vimrpc#stop()
python3 << endPython
	runThread = False
endPython
endfunction

call vimrpc#run()
