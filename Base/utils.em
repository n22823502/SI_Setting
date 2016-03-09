/* Utils.em - a small collection of useful editing macros */



/*-------------------------------------------------------------------------
	I N S E R T   H E A D E R

	Inserts a comment header block at the top of the current function. 
	This actually works on any type of symbol, not just functions.

	To use this, define an environment variable "MYNAME" and set it
	to your email name.  eg. set MYNAME=raygr
-------------------------------------------------------------------------*/
macro InsertHeader()
{
	// Get the owner's name from the environment variable: MYNAME.
	// If the variable doesn't exist, then the owner field is skipped.
	szMyName = getenv(MYNAME)
	
	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)

	// begin assembling the title string
	sz = "/*   "
	
	/* convert symbol name to T E X T   L I K E   T H I S */
	cch = strlen(szFunc)
	ich = 0
	while (ich < cch)
		{
		ch = szFunc[ich]
		if (ich > 0)
			if (isupper(ch))
				sz = cat(sz, "   ")
			else
				sz = cat(sz, " ")
		sz = Cat(sz, toupper(ch))
		ich = ich + 1
		}
	
	sz = Cat(sz, "   */")
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln+1, "/*-------------------------------------------------------------------------")
	
	/* if owner variable exists, insert Owner: name */
	if (strlen(szMyName) > 0)
		{
		InsBufLine(hbuf, ln+2, "    Owner: @szMyName@")
		InsBufLine(hbuf, ln+3, " ")
		ln = ln + 4
		}
	else
		ln = ln + 2
	
	InsBufLine(hbuf, ln,   "    ") // provide an indent already
	InsBufLine(hbuf, ln+1, "-------------------------------------------------------------------------*/")
	
	// put the insertion point inside the header comment
	SetBufIns(hbuf, ln, 4)
}


/* InsertFileHeader:

   Inserts a comment header block at the top of the current function. 
   This actually works on any type of symbol, not just functions.

   To use this, define an environment variable "MYNAME" and set it
   to your email name.  eg. set MYNAME=raygr
*/

macro InsertFileHeader()
{
	szMyName = getenv(MYNAME)
	
	hbuf = GetCurrentBuf()

	InsBufLine(hbuf, 0, "/*-------------------------------------------------------------------------")
	
	/* if owner variable exists, insert Owner: name */
	InsBufLine(hbuf, 1, "    ")
	if (strlen(szMyName) > 0)
		{
		sz = "    Owner: @szMyName@"
		InsBufLine(hbuf, 2, " ")
		InsBufLine(hbuf, 3, sz)
		ln = 4
		}
	else
		ln = 2
	
	InsBufLine(hbuf, ln, "-------------------------------------------------------------------------*/")
}



// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	ln = GetBufLineCur(hbuf)

	InsBufLine(hbuf, ln, "    Returns True if successful or False if errors.")
}



/* Inserts ifdef REVIEW around the selection */
macro IfdefReview()
{
	IfdefSz("REVIEW");
}


/* Inserts ifdef BOGUS around the selection */
macro IfdefBogus()
{
	IfdefSz("BOGUS");
}


/* Inserts ifdef NEVER around the selection */
macro IfdefNever()
{
	IfdefSz("NEVER");
}


// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
	sz = Ask("Enter ifdef condition:")
	if (sz != "")
		IfdefSz(sz);
}

macro InsertCPlusPlus()
{
	IfdefSz("__cplusplus");
}


// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}


// Delete the current line and appends it to the clipboard buffer
macro KillLine()
{
	hbufCur = GetCurrentBuf();
	lnCur = GetBufLnCur(hbufCur)
	hbufClip = GetBufHandle("Clipboard")
	AppendBufLine(hbufClip, GetBufLine(hbufCur, lnCur))
	DelBufLine(hbufCur, lnCur)
}


// Paste lines killed with KillLine (clipboard is emptied)
macro PasteKillLine()
{
	Paste
	EmptyBuf(GetBufHandle("Clipboard"))
}



// delete all lines in the buffer
macro EmptyBuf(hbuf)
{
	lnMax = GetBufLineCount(hbuf)
	while (lnMax > 0)
		{
		DelBufLine(hbuf, 0)
		lnMax = lnMax - 1
		}
}


// Ask the user for a symbol name, then jump to its declaration
macro JumpAnywhere()
{
	symbol = Ask("What declaration would you like to see?")
	JumpToSymbolDef(symbol)
}

	
// list all siblings of a user specified symbol
// A sibling is any other symbol declared in the same file.
macro OutputSiblingSymbols()
{
	symbol = Ask("What symbol would you like to list siblings for?")
	hbuf = ListAllSiblings(symbol)
	SetCurrentBuf(hbuf)
}


// Given a symbol name, open the file its declared in and 
// create a new output buffer listing all of the symbols declared
// in that file.  Returns the new buffer handle.
macro ListAllSiblings(symbol)
{
	loc = GetSymbolLocation(symbol)
	if (loc == "")
		{
		msg ("@symbol@ not found.")
		stop
		}
	
	hbufOutput = NewBuf("Results")
	
	hbuf = OpenBuf(loc.file)
	if (hbuf == 0)
		{
		msg ("Can't open file.")
		stop
		}
		
	isymMax = GetBufSymCount(hbuf)
	isym = 0;
	while (isym < isymMax)
		{
		AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		isym = isym + 1
		}

	CloseBuf(hbuf)
	
	return hbufOutput

}





macro CommentMultiLine_if0()
{
        hwnd=GetCurrentWnd()
        sel=GetWndSel(hwnd)
        lnFirst=GetWndSelLnFirst(hwnd)
        lnLast=GetWndSelLnLast(hwnd)
        hbuf=GetCurrentBuf()
        
        if (LnFirst == 0) {
                szIfStart = ""
        } else {
                szIfStart = GetBufLine(hbuf, LnFirst-1)
        }
        szIfEnd = GetBufLine(hbuf, lnLast+1)
        if (szIfStart == "#if 0" && szIfEnd == "#endif") {
                DelBufLine(hbuf, lnLast+1)
                DelBufLine(hbuf, lnFirst-1)
 //               sel.lnFirst = sel.lnFirst -1
 //               sel.lnLast = sel.lnLast – 1
        } else {
                InsBufLine(hbuf, lnFirst, "#if 0")
                InsBufLine(hbuf, lnLast+2, "#endif")
                sel.lnFirst = sel.lnFirst + 1
                sel.lnLast = sel.lnLast + 1
        }
        SetWndSel( hwnd, sel )
}


macro _tsGetTabSize()
{
	szTabSize = GetReg("TabSize");

	if (szTabSize != "")
	{
		tabSize = AsciiFromChar(szTabSize[0]) - AsciiFromChar("0");
	}
	else
	{
		tabSize = 4;
	}

	return tabSize;
}


macro CommentBlock_Joyce()
{
	hbuf = GetCurrentBuf();
	hwnd = GetCurrentWnd();

	sel = GetWndSel(hwnd);

	iLine = sel.lnFirst;
	
	// indicate the comment char according to the file type
	// for example, using "#" for perl file(.pl) and "/* */" for C/C++.
	filename = tolower(GetBufName(hbuf));
	suffix = "";
	len = strlen(filename);
	i = len - 1;
	while (i >= 0)
	{
		if (filename[i-1] == ".")
		{
			suffix = strmid(filename, i, len)
			break;
		}
		i = i -1;
	}
	if  ( suffix == "pl" )
	{
		filetype = 2; // PERL
	}
	else
	{
		filetype = 1; // C
	}

	szLine = GetBufLine(hbuf, iLine);
	if (filetype == 1) 	// C
	{
		szLine = cat("/*	", szLine);
	}
	else				// PERL
	{
		szLine = cat("#	", szLine);
	}
	PutBufLine(hbuf, iLine, szLine);
	iLine = sel.lnLast;
	szLine = GetBufLine(hbuf, iLine);
	if (filetype == 1) 	// C
	{
		szLine = cat(szLine, "*/	");
	}
	else				// PERL
	{
		szLine = cat("#	", szLine);
	}
	PutBufLine(hbuf, iLine, szLine);



	if (sel.lnFirst == sel.lnLast)
	{
		tabSize = _tsGetTabSize() - 1;
		sel.ichFirst = sel.ichFirst + tabSize;
		sel.ichLim = sel.ichLim + tabSize;
	}
	SetWndSel(hwnd, sel);
}




//
// Undo the CommentBlock for the selected text.
//
macro UnCommentBlock_Joyce()
{
	hbuf = GetCurrentBuf();
	hwnd = GetCurrentWnd();
	
	sel = GetWndSel(hwnd);

	iLine = sel.lnFirst;


	// indicate the comment char according to the file type
	// for example, using "#" for perl file(.pl) and "/* */" for C/C++.
	filename = tolower(GetBufName(hbuf));
	suffix = "";
	len = strlen(filename);
	i = len - 1;
	while (i >= 0)
	{
		if (filename[i-1] == ".")
		{
			suffix = strmid(filename, i, len)
			break;
		}
		i = i -1;
	}
	if  ( suffix == "pl" )
	{
		filetype = 2; // PERL
	}
	else
	{
		filetype = 1; // C
	}

	tabSize = 0;

	endLine = GetBufLine(hbuf, sel.lnLast);
	endLineLen = strlen(endLine);
	szLine = GetBufLine(hbuf, iLine);
	len = strlen(szLine);
	szNewLine = "";
	commentState = 1;

	if (szLine[0] == "/" && szLine[1] == "*")
	{
		if(endLine[endLineLen-2] == "/" && endLine[endLineLen-3] == "*")
		{
			if (filetype == 1) 	// C
			{
				if (len > 1)
				{
					if (szLine[0] == "/" && szLine[1] == "*")
					{
						if (len > 2)
						{
							if (AsciiFromChar(szLine[2]) == 9)
							{
								tabSize = _tsGetTabSize() - 1;
								szNewLine = strmid(szLine, 3, strlen(szLine));
							}
						}

						if (szNewLine == "")
						{
							szNewLine = strmid(szLine, 2, strlen(szLine));
							tabSize = 2;
						}
						
						PutBufLine(hbuf, iLine, szNewLine);
					}
				}
			}
			if (filetype == 2) 	// PERL
			{
				if (len > 0)
				{
					if (szLine[0] == "#")	
					{
						if (len > 1)
						{
							if (AsciiFromChar(szLine[1]) == 9)
							{
								tabSize = _tsGetTabSize() - 1;
								szNewLine = strmid(szLine, 2, strlen(szLine));
							}
						}

						if (szNewLine == "")
						{
							szNewLine = strmid(szLine, 1, strlen(szLine));
							tabSize = 2;
						}
						
						PutBufLine(hbuf, iLine, szNewLine);
					}
				}
			}

			iLine = sel.lnLast;
			szLine = GetBufLine(hbuf, iLine);
			len = strlen(szLine);
			szNewLine = "";
			if (filetype == 1) 	// C
			{
				if (len > 1)
				{
					if (szLine[strlen(szLine)-2] == "/" && szLine[strlen(szLine)-3] == "*")
					{
						if (len > 2)
						{
							if (AsciiFromChar(szLine[2]) == 9)
							{
								tabSize = _tsGetTabSize() - 1;
								szNewLine = strmid(szLine, 0, strlen(szLine)-2);
							}
						}

						if (szNewLine == "")
						{
							szNewLine = strmid(szLine, 0, strlen(szLine)-3);
							tabSize = 2;
						}
						
						PutBufLine(hbuf, iLine, szNewLine);
					}
				}
			}
			if (filetype == 2) 	// PERL
			{
				if (len > 0)
				{
					if (szLine[0] == "#")	
					{
						if (len > 1)
						{
							if (AsciiFromChar(szLine[1]) == 9)
							{
								tabSize = _tsGetTabSize() - 1;
								szNewLine = strmid(szLine, 2, strlen(szLine));
							}
						}

						if (szNewLine == "")
						{
							szNewLine = strmid(szLine, 1, strlen(szLine));
							tabSize = 2;
						}
						
						PutBufLine(hbuf, iLine, szNewLine);
					}
				}
			}
		}

	}
	

	if (sel.lnFirst == sel.lnLast)
	{
		sel.ichFirst = sel.ichFirst - tabSize;
		sel.ichLim = sel.ichLim - tabSize;
	}

	SetWndSel(hwnd, sel);
}


macro SingleLineComment()
{
szMyName = "Boyce"
// Get a handle to the current file buffer and the name
// and location of the current symbol where the cursor is.
hbuf = GetCurrentBuf()
ln = GetBufLnCur(hbuf)

// Get current time
szTime = GetSysTime(1)
Hour = szTime.Hour
Minute = szTime.Minute
Second = szTime.Second
Day = szTime.Day
Month = szTime.Month
Year = szTime.Year
if (Day < 10)
szDay = "0@Day@"
else
szDay = Day
//szMonth = NumToName(Month)
if (Month < 10)
     szMonth = "0@Month@"
else
szMonth = Month

szDescription = Ask("請輸入修改原因")
// begin assembling the title string
InsBufLine(hbuf, ln+1, "/*@szDescription@ @szMyName@ @Year@-@szMonth@-@szDay@*/")
}

macro MultiLineCommentHeader()
{
szMyName = "Boyce"
// Get a handle to the current file buffer and the name
// and location of the current symbol where the cursor is.
hbuf = GetCurrentBuf()
ln = GetBufLnCur(hbuf)

// Get current time
szTime = GetSysTime(1)
Hour = szTime.Hour
Minute = szTime.Minute
Second = szTime.Second
Day = szTime.Day
Month = szTime.Month
Year = szTime.Year
if (Day < 10)
szDay = "0@Day@"
else
szDay = Day
//szMonth = NumToName(Month)
if (Month < 10)
     szMonth = "0@Month@"
else
szMonth = Month

szDescription = Ask("請輸入修改原因:")
// begin assembling the title string
InsBufLine(hbuf, ln + 1, "/*@szDescription@ @szMyName@ @Year@-@szMonth@-@szDay@ begin*/")
}

macro MultiLineCommentEnd()
{
szMyName = "Boyce"
// Get a handle to the current file buffer and the name
// and location of the current symbol where the cursor is.
hbuf = GetCurrentBuf()
ln = GetBufLnCur(hbuf)

// Get current time
szTime = GetSysTime(1)
Hour = szTime.Hour
Minute = szTime.Minute
Second = szTime.Second
Day = szTime.Day
Month = szTime.Month
Year = szTime.Year
if (Day < 10)
szDay = "0@Day@"
else
szDay = Day
//szMonth = NumToName(Month)
if (Month < 10)
     szMonth = "0@Month@"
else
szMonth = Month

InsBufLine(hbuf, ln + 1, "/*@szMyName@ @Year@-@szMonth@-@szDay@ end*/")
}


//
// Comment the selected block of text using single line comments and indent it
//
macro CommentBlock()
{
	hbuf = GetCurrentBuf();
	hwnd = GetCurrentWnd();

	sel = GetWndSel(hwnd);

	iLine = sel.lnFirst;
	
	// added by Yongqiang, indicate the comment char according to the file type
	// for example, using "#" for perl file(.pl) and "//" for others.
	filename = tolower(GetBufName(hbuf));
	suffix = "";
	len = strlen(filename);
	i = len - 1;
	while (i >= 0)
	{
		if (filename[i-1] == ".")
		{
			suffix = strmid(filename, i, len)
			break;
		}
		i = i -1;
	}
	if  ( suffix == "pl" )
	{
		filetype = 2; // PERL
	}
	else
	{
		filetype = 1; // C
	}

	while (iLine <= sel.lnLast)
	{
		szLine = GetBufLine(hbuf, iLine);
		if (filetype == 1) 	// C
		{
			szLine = cat("//	", szLine);
		}
		else				// PERL
		{
			szLine = cat("#	", szLine);
		}
		PutBufLine(hbuf, iLine, szLine);
		iLine = iLine + 1;
	}

	if (sel.lnFirst == sel.lnLast)
	{
		tabSize = _tsGetTabSize() - 1;
		sel.ichFirst = sel.ichFirst + tabSize;
		sel.ichLim = sel.ichLim + tabSize;
	}
	SetWndSel(hwnd, sel);
}


//
// Undo the CommentBlock for the selected text.
//
macro UnCommentBlock()
{
	hbuf = GetCurrentBuf();
	hwnd = GetCurrentWnd();
	
	sel = GetWndSel(hwnd);

	iLine = sel.lnFirst;


	// added by Yongqiang, indicate the comment char according to the file type
	// for example, using "#" for perl file(.pl) and "//" for others.
	filename = tolower(GetBufName(hbuf));
	suffix = "";
	len = strlen(filename);
	i = len - 1;
	while (i >= 0)
	{
		if (filename[i-1] == ".")
		{
			suffix = strmid(filename, i, len)
			break;
		}
		i = i -1;
	}
	if  ( suffix == "pl" )
	{
		filetype = 2; // PERL
	}
	else
	{
		filetype = 1; // C
	}

	tabSize = 0;
	while (iLine <= sel.lnLast)
	{
		szLine = GetBufLine(hbuf, iLine);
		len = strlen(szLine);
		szNewLine = "";
		if (filetype == 1) 	// C
		{
			if (len > 1)
			{
				if (szLine[0] == "/" && szLine[1] == "/")
				{
					if (len > 2)
					{
						if (AsciiFromChar(szLine[2]) == 9)
						{
							tabSize = _tsGetTabSize() - 1;
							szNewLine = strmid(szLine, 3, strlen(szLine));
						}
					}

					if (szNewLine == "")
					{
						szNewLine = strmid(szLine, 2, strlen(szLine));
						tabSize = 2;
					}
					
					PutBufLine(hbuf, iLine, szNewLine);
				}
			}
		}
		if (filetype == 2) 	// PERL
		{
			if (len > 0)
			{
				if (szLine[0] == "#")	
				{
					if (len > 1)
					{
						if (AsciiFromChar(szLine[1]) == 9)
						{
							tabSize = _tsGetTabSize() - 1;
							szNewLine = strmid(szLine, 2, strlen(szLine));
						}
					}

					if (szNewLine == "")
					{
						szNewLine = strmid(szLine, 1, strlen(szLine));
						tabSize = 2;
					}
					
					PutBufLine(hbuf, iLine, szNewLine);
				}
			}
		}
		iLine = iLine + 1;
	}

	if (sel.lnFirst == sel.lnLast)
	{
		sel.ichFirst = sel.ichFirst - tabSize;
		sel.ichLim = sel.ichLim - tabSize;
	}

	SetWndSel(hwnd, sel);
}


macro MultiLine_Comment()
{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst = GetWndSelLnFirst(hwnd)     
    LnLast = GetWndSelLnLast(hwnd)     
    hbuf = GetCurrentBuf()
  
    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031"){
        stop
    }
  
    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len =strlen(buf)
  
    while(Ln <= Lnlast) {
        buf = GetBufLine(hbuf, Ln) 
        if(buf ==""){                   
            Ln = Ln + 1
            continue
        }
  
        if(StrMid(buf, 0, 1) =="/") {       
            if(StrMid(buf, 1, 2) =="/"){
                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))
            }
        }
  
        if(StrMid(buf,0,1) !="/"){          
            PutBufLine(hbuf, Ln, Cat("//", buf))
        }
        Ln = Ln + 1
    }
  
    SetWndSel(hwnd, selection)
}