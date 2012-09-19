#!/usr/bin/python
# -*- coding: utf-8 -*-


#On OS X, exec with arch -i386 python2.7 filename.py

import wx, wx.richtext
class ExamplePanel(wx.Panel):
    def foo(self,param):
		print "foo"
    def __init__(self, parent):
        wx.Panel.__init__(self, parent)
        col0 = 2;col1 = 50;col2 = 200;col3 = 230;col4 = 238;col5=290
        row0 = 25;row1 = 65;row2 = 105;row3 = 145
        
        self.vol0 = wx.StaticText(self, label="Vol 0:", pos=(col0, row0))
        self.vol1 = wx.StaticText(self, label="Vol 1:", pos=(col0, row1))
        self.vol2 = wx.StaticText(self, label="Vol 2:", pos=(col0, row2))
        self.vol3 = wx.StaticText(self, label="Vol 3:", pos=(col0, row3))
        self.vol0bsgi = wx.StaticText(self, label="BaseStation",pos=(col1,row0))
        self.vol1bsgi = wx.StaticText(self, label="BaseStation",pos=(col1,row1))
        self.vol2bsgi = wx.StaticText(self, label="BaseStation",pos=(col1,row2))
        self.vol3bsgi = wx.StaticText(self, label="BaseStation",pos=(col1,row3))
        self.vol0bsgibox = wx.StaticBox(self, pos=(col1-5,row0-8),size=(200,40))
        self.vol1bsgibox = wx.StaticBox(self, pos=(col1-5,row1-8),size=(200,40))
        self.vol2bsgibox = wx.StaticBox(self, pos=(col1-5,row2-8),size=(200,40))
        self.vol3bsgibox = wx.StaticBox(self, pos=(col1-5,row3-8),size=(200,40))
        png = wx.Image("trash.png", wx.BITMAP_TYPE_ANY).ConvertToBitmap()
        
        self.delete0 = wx.BitmapButton(self, id=-1, bitmap=png,pos=(col3 + png.GetWidth(), row0), size = (png.GetWidth()+5, png.GetHeight()+5))
        self.delete0.Bind(wx.EVT_BUTTON, self.foo)
        self.delete1 = wx.BitmapButton(self, id=-1, bitmap=png,pos=(col3 + png.GetWidth(), row1), size = (png.GetWidth()+5, png.GetHeight()+5))
        self.delete1.Bind(wx.EVT_BUTTON, self.foo)
        self.delete2 = wx.BitmapButton(self, id=-1, bitmap=png,pos=(col3 + png.GetWidth(), row2), size = (png.GetWidth()+5, png.GetHeight()+5))
        self.delete2.Bind(wx.EVT_BUTTON, self.foo)
        self.delete3 = wx.BitmapButton(self, id=-1, bitmap=png,pos=(col3 + png.GetWidth(), row3), size = (png.GetWidth()+5, png.GetHeight()+5))
        self.delete3.Bind(wx.EVT_BUTTON, self.foo)
        
        self.delugeTitle = wx.StaticText(self, label="Deluge", pos=(col4, col0))
        self.delugeTitle = wx.StaticText(self, label="▼", pos=(col4+37, col0+14))
        font = wx.Font(8, wx.DECORATIVE, wx.ITALIC, wx.NORMAL)
        self.delugeTitle.SetFont(font)
        self.goldenImageTitle = wx.StaticText(self, label="Golden Image", pos=(col5, col0))
        self.goldenImageTitle = wx.StaticText(self, label="▼", pos=(col5+6, col0+14))
        font = wx.Font(8, wx.DECORATIVE, wx.ITALIC, wx.NORMAL)
        self.goldenImageTitle.SetFont(font)
        
        installpng = wx.Image("load.png", wx.BITMAP_TYPE_ANY).ConvertToBitmap()
        col4point5 = col4 + installpng.GetWidth() +15
        col5point5 = col5 + installpng.GetWidth() -15
        self.installD0 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col4point5, row0), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installD0.Bind(wx.EVT_BUTTON, self.foo)
        self.installD1 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col4point5, row1), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installD1.Bind(wx.EVT_BUTTON, self.foo)
        self.installD2 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col4point5, row2), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installD2.Bind(wx.EVT_BUTTON, self.foo)
        self.installD3 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col4point5, row3), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installD3.Bind(wx.EVT_BUTTON, self.foo)        
        
        self.installGI0 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col5point5, row0), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installGI0.Bind(wx.EVT_BUTTON, self.foo)
        self.installGI1 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col5point5, row1), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installGI1.Bind(wx.EVT_BUTTON, self.foo)
        self.installGI2 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col5point5, row2), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installGI2.Bind(wx.EVT_BUTTON, self.foo)
        self.installGI3 = wx.BitmapButton(self, id=-1, bitmap=installpng,pos=(col5point5, row3), size = (installpng.GetWidth()+5, installpng.GetHeight()+5))
        self.installGI3.Bind(wx.EVT_BUTTON, self.foo)       
        
        return
        
        # A multiline TextCtrl - This is here to show how the events work in this program, don't pay too much attention to it
        self.logger = wx.TextCtrl(self, pos=(300,20), size=(200,300), style=wx.TE_MULTILINE | wx.TE_READONLY)

        # A button
        self.button =wx.Button(self, label="Save", pos=(200, 325))
        self.Bind(wx.EVT_BUTTON, self.OnClick,self.button)

        # the edit control - one line version.
        self.lblname = wx.StaticText(self, label="Your name :", pos=(20,60))
        self.editname = wx.TextCtrl(self, value="Enter here your name", pos=(150, 60), size=(140,-1))
        self.Bind(wx.EVT_TEXT, self.EvtText, self.editname)
        self.Bind(wx.EVT_CHAR, self.EvtChar, self.editname)

        # the combobox Control
        self.sampleList = ['friends', 'advertising', 'web search', 'Yellow Pages']
        self.lblhear = wx.StaticText(self, label="How did you hear from us ?", pos=(20, 90))
        self.edithear = wx.ComboBox(self, pos=(150, 90), size=(95, -1), choices=self.sampleList, style=wx.CB_DROPDOWN)
        self.Bind(wx.EVT_COMBOBOX, self.EvtComboBox, self.edithear)
        self.Bind(wx.EVT_TEXT, self.EvtText,self.edithear)

        # Checkbox
        self.insure = wx.CheckBox(self, label="Do you want Insured Shipment ?", pos=(20,180))
        self.Bind(wx.EVT_CHECKBOX, self.EvtCheckBox, self.insure)

        # Radio Boxes
        radioList = ['blue', 'red', 'yellow', 'orange', 'green', 'purple', 'navy blue', 'black', 'gray']
        rb = wx.RadioBox(self, label="What color would you like ?", pos=(20, 210), choices=radioList,  majorDimension=3,
                         style=wx.RA_SPECIFY_COLS)
        self.Bind(wx.EVT_RADIOBOX, self.EvtRadioBox, rb)

    def EvtRadioBox(self, event):
        self.logger.AppendText('EvtRadioBox: %d\n' % event.GetInt())
    def EvtComboBox(self, event):
        self.logger.AppendText('EvtComboBox: %s\n' % event.GetString())
    def OnClick(self,event):
        self.logger.AppendText(" Click on object with Id %d\n" %event.GetId())
    def EvtText(self, event):
        self.logger.AppendText('EvtText: %s\n' % event.GetString())
    def EvtChar(self, event):
        self.logger.AppendText('EvtChar: %d\n' % event.GetKeyCode())
        event.Skip()
    def EvtCheckBox(self, event):
        self.logger.AppendText('EvtCheckBox: %d\n' % event.Checked())


app = wx.App(False)
frame = wx.Frame(None)
panel = ExamplePanel(frame)
frame.Show()
app.MainLoop()
