#!/usr/bin/python
# -*- coding: iso-8859-1 -*-
# 05262011 MAT Acquisition of Deluge and ModifiedDeluge sources and placement in the local filesystem
# 05252011 MAT Initial Implementation

import Tkinter, subprocess, shlex, os, urllib, tarfile, string
from Tkinter import *


class motesGUI(Tkinter.Tk):
    URL_DELUGE_BASES = "http://cs.odu.edu/~mkelly/motes/DelugeBases.tar.gz"	#Base Deluge and Deluge modified by NASA folk in a single archive	
    ERROR_NEED_DELUGE_BASES = "You need Deluge in ~/DelugeBases"			#Warning that Deluge cannot be changed until we get the sources
    DIR_LOCAL_DELUGE_BASES = "~/DelugeBases"								
    DIR_DELUGE_BASES_TAR_GZ = "/DelugeBases.tar.gz"
    DIR_DELUGE = "/opt/tinyos-2.1.1/tos/lib/net/Deluge/"    
   
	
    def __init__(self,parent):
        Tkinter.Tk.__init__(self,parent)
        self.parent = parent
        self.initialize()
	self.determineVersionOfDelugeInstalled()
	

    NUMBER_OF_BUTTONS_VISIBLE = 0
    def addButton(self,textIn,commandIn=None,rowIn=None,widthIn=30,colspan=2,stickyIn='',colIn=0): 
	    #addButton: a portable means for creating GUI button with only the parameters necessary
	    rrow = rowIn
	    wwidth = widthIn
	    if rrow == None:
		rrow = self.NUMBER_OF_BUTTONS_VISIBLE
		self.NUMBER_OF_BUTTONS_VISIBLE = self.NUMBER_OF_BUTTONS_VISIBLE+1	# <|-- assume that the next button will be added to the subsequent row
	    else:															#    |
		 self.NUMBER_OF_BUTTONS_VISIBLE = rowIn + 1						# <|
		 
            if wwidth == None:
		wwidth = 30
	     
	    button = Tkinter.Button(self,text=textIn,width=str(wwidth),
                                command=commandIn)
	    button.grid(column=colIn,row=str(rrow),columnspan=str(colspan),sticky=stickyIn)
	    return button
	    
    def determineVersionOfDelugeInstalled(self):
	    file = open(self.DIR_DELUGE+"DelugeP.nc","r")
	    #file2 = open("/home/machawk1/Downloads/RetaskingProject/tinyos-2.1.1/tos/lib/net/Deluge/DelugeP.nc","r")
	    fileContents = file.read()
	    #fileContents2 = file2.read()
	    delugeModified = (string.find(fileContents,"VersionMsg") != -1)
	    #if contains "VersionMsg", deluge version is modified version
	    if delugeModified:
		    print "Deluge Modified"
	    else:
		    print "Deluge NOT Modified"
	    #if hash == ?????, deluge version is original (determine hash of string acquired above)
	    
    def installDeluge(self,version="base"):
	    BASE_PATH = os.path.expanduser("~")+"/DelugeBases/Original/"
	    PROTOTYPE_PATH = os.path.expanduser("~")+"/DelugeBases/Prototype/"
	    		
	    
	    THE_CHOSEN_PATH = BASE_PATH
	    if version=="prototype":
		    THE_CHOSEN_PATH = PROTOTYPE_PATH
	    
	    print "In installDeluge()"
	    for dirname, dirnames, filenames in os.walk(THE_CHOSEN_PATH):
		    #for subdirname in dirnames:
			#print subdirname
#			print os.path.join(dirname, subdirname)
		    for filename in filenames:
			print "cp "+os.path.join(dirname, filename)+" "+self.DIR_DELUGE+filename
			#print os.path.join(dirname, filename)
			#print dirname+" "+filename
    def initialize(self):
        self.grid()
	
	COLSPAN_1_COL = 1					#button spans only 1 column
	COLSPAN_2_COL = 2					#button spans 2 columns
	DELUGE_BUTTON_INSTALL_ROW = 3		#row/location on which the multiple Deluge button should reside
	BUTTON_WIDTH_HALF_COL = 12		#because the Deluge buttons install on the same row, make them less than half the width so they can both fit
	
	startingStatusMessage = "Idle"
	
	button1 = self.addButton("Init Mote With GoldenImage and Erase",	lambda: self.initMoteWithGoldenImage(True))
	button2 = self.addButton("Init Mote with BaseStation and Erase",	lambda:self.initMoteWithBasestationImage(True))
	button3 = self.addButton("Inject Program Onto Basestation",		lambda:self.injectProgramOntoBasestation())
        
	#Deluge fetch buttons
	self.button3a = self.addButton("Base Deluge",			lambda:self.installDeluge()		,						DELUGE_BUTTON_INSTALL_ROW,BUTTON_WIDTH_HALF_COL,			COLSPAN_1_COL,"W")
	self.button3b = self.addButton("Custom Deluge",			lambda:self.installDeluge("prototype")	,						DELUGE_BUTTON_INSTALL_ROW,BUTTON_WIDTH_HALF_COL,			COLSPAN_1_COL,"E")
	self.button3c = self.addButton("Get Deluge Code Bases",	lambda:self.getDelugeBasesFromTheWeb(),	DELUGE_BUTTON_INSTALL_ROW,None,				    			COLSPAN_2_COL)
	
	self.displayAppropriateGetDelugeButtons()

	#button4 = self.addButton("Get Mote Info",						lambda:self.getMoteInfo())
	
	self.entryVariable = Tkinter.StringVar()
        self.entry = Tkinter.Entry(self,textvariable=self.entryVariable)
        self.entry.grid(column=0,row=5,columnspan=2,sticky='EW')
        #self.entry.bind("<Return>", self.OnPressEnter)
        self.entryVariable.set("/opt/tinyos-2.1.1/apps/MatAllocate")
	
        self.labelVariable = Tkinter.StringVar()
        label = Tkinter.Label(self,textvariable=self.labelVariable, width="30", anchor="w")
        label.grid(column=0,row=6,columnspan=2)
        self.labelVariable.set(startingStatusMessage)

	#not implemented, allow multiple clearing of client motes
	#mirrorStart = Tkinter.Button(self,text=u"",width="30",bg="black",fg="white",state="disabled",
          #                      command=lambda: self.initMoteWithGoldenImage(False))
        #mirrorStart.grid(column=0,row=6)	

	#mirrorStart.destroy()

        self.grid_columnconfigure(0,weight=1)
        self.resizable(True,False)
        self.update()
        self.geometry(self.geometry())       

    def displayAppropriateGetDelugeButtons(self):
	
	if os.path.isdir(os.path.expanduser(self.DIR_LOCAL_DELUGE_BASES)):
		self.button3a.grid()			#show "Base Deluge" button
		self.button3b.grid()			#show "Modified Deluge" button
		self.button3c.grid_remove()	#hide "Get Deluge" button
	else:
		self.startingStatusMessage = self.ERROR_NEED_DELUGE_BASES	
		self.button3a.grid_remove()	#hide "Base Deluge" button
		self.button3b.grid_remove()	#hide "Modified Deluge" button
		self.button3c.grid()			#show "Get Deluge" button
		
    def getMoteInfo(self):
	    cmd = "tos-deluge serial@/dev/ttyUSB1:57600 -p 1"
	    msg = subprocess.check_output(subprocess.call(shlex.split(cmd), subprocess.call(shlex.split(cmd))))
	   # self.runCommand(cmd)
	    x= subprocess.call(shlex.split(cmd))
	    #TODO: parse output and display somehow
	    
    def getDelugeBasesFromTheWeb(self):
	 #TODO: automatically download Deluge Bases: Original and Prototype from cs.odu.edu/~mkelly/motes/
	
	
	urllib.urlretrieve(self.URL_DELUGE_BASES,os.path.expanduser("~")+self.DIR_DELUGE_BASES_TAR_GZ)
	tar = tarfile.open(os.path.expanduser("~")+self.DIR_DELUGE_BASES_TAR_GZ)
	tar.extractall()
	tar.close()
	
	#x = self.runCommand("tar -xzf "+os.path.expanduser("~")+"/DelugeBases.tar.gz")
	y = self.runCommand("mv "+os.path.abspath("./").replace(' ', r'\ ')+"/DelugeBases/ "+os.path.expanduser("~")+"/DelugeBases/")
	
	#TODO: change permissions of the newly created file so we don't accidently write over the bases  

	self.displayAppropriateGetDelugeButtons()
    def initMoteWithGoldenImage(self,andErase): 
	try:
	  self.alert("Initializing mote with GoldenImage")
	  self.runCommand("make -C /opt/tinyos-2.1.1/apps/tests/deluge/GoldenImage iris install,1 mib520,/dev/ttyUSB0 > /dev/null")
	  if(andErase):
		self.runCommand("tos-deluge serial@/dev/ttyUSB1:57600 -e 1")
		self.runCommand("tos-deluge serial@/dev/ttyUSB1:57600 -e 1")
	  self.alert("Idle")
	except Exception as e:
		if e.args[0]==255:
			self.alert("ERROR! Mote not connected")
		else:
			self.alert("An unknown exception unoccured")
    def mirrorMultipleMotesWithGoldenImage(self,andErase):
	self.alert("Mirroring Motes, hit ok when ready")
	#self.mirrorStart.config(text="Init Mote With GoldenImage and Erase")   

    def initMoteWithBasestationImage(self,andErase):
 	self.alert("Initializing mote with Basestation image")
	
	self.runCommand("make -C /opt/tinyos-2.1.1/apps/tests/deluge/Basestation iris install,0 mib520,/dev/ttyUSB0")
	if(andErase):
		self.runCommand("tos-deluge serial@/dev/ttyUSB1:57600 -e 1") 
		#TODO: check, after this first command, if the erase error is "5". If so, run the second command
		self.runCommand("tos-deluge serial@/dev/ttyUSB1:57600 -e 1") #For some reason, after getting an error 5 after erase, a second erase session does the trick
		
	self.alert("Idle")
    def injectProgramOntoBasestation(self):
	self.alert("Injecting Program onto mote with Basestation")
	#verify that mote has basestation installed
	
	# WORKAROUND: re-install basestation
	self.alert("Re-installing Basestation image")
	self.initMoteWithBasestationImage(0)
        #erase volume 1
	self.alert("Erasing Volume 1")
	#self.runCommand("tos-deluge serial@/dev/ttyUSB1:57600 -e 1")
	
	#compile program
	#self.alert("Compiling the program")
	
	self.runCommand("make -C "+self.entry.get()+" iris")
	
        #pull fresh tos_image.xml
        #self.alert("Pulling a fresh tos_image.xml")
        #self.runCommand("cp /opt/tinyos-2.1.1/apps/tests/deluge/BoldenImage/volumes-at45db.xml "+self.entry.get()+"/tos_image.xml)

	#inject
	self.alert("Injecting the program onto the Basetation, volume 1")
	self.runCommand("tos-deluge serial@/dev/ttyUSB1:57600 -i 1 "+self.entry.get()+"/build/iris/tos_image.xml")
	
	#verify  installation
	
	self.alert("Idle")

    def runCommand(self,cmd):
	print cmd
	#verify that the command is not harmful
	#Message(Tk(), text=shlex.split(cmd), width='500px').pack(padx=10, pady=10)
	
	#run the command
	ret = subprocess.call(shlex.split(cmd))
	
	if ret==255: #mote wasn't connected
		raise Exception(255)
	else:
		print ret
    def alert(self,msg):
	   self.labelVariable.set(msg)
	   self.update()
    def OnButtonClick(self):
	self.labelVariable.set( self.labelVariable.get()+" (You clicked the button)" )
	# ************************
	# 
	
       # self.entry.focus_set()
        #self.entry.selection_range(0, Tkinter.END)
'''
    def OnPressEnter(self,event):
        self.labelVariable.set( self.entryVariable.get()+" (You pressed ENTER)" )
        self.entry.focus_set()
        self.entry.selection_range(0, Tkinter.END)
'''
if __name__ == "__main__":
    app = motesGUI(None)
    app.title('Mat\'s Mote Control')
    app.mainloop()
