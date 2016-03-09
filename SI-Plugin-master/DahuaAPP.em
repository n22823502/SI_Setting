/*
//��Source Insight���
v0.12.0

//�˲���ںϸ����������
//�޸�ʹ�����ڴ󻪣�����з�����Ч��
//
//2014��5��17��
//
//
//���ܣ�
//1��tab��
//�Զ���ȫ����if else while for 
//trace include main
//2�����뺯����
//InsertFuncName
//InsertPoint
//4������ƶ�
//���ף���β
//
//5��svn���
//log diff blace explorer
//
//6��ע��
//����ע��
//Doxygen�ĵ�ע�ͣ�������
//6���������Ctrl+Enter
//
//7���ļ�����
//�ļ��л�Ctrl+d
*/

/*********************Start Base Functions*********************/

/*
* �����������ַ�����������word���ǿ��ַ�λ��
*
*/

//���� str1��n�γ��ֵ�λ�ã�����
macro strstr(str,str1,n)
{
    len = strlen(str)
    len1 = strlen(str1)
    i = 0

    times = 0
    while( i <= len - len1 )
    {
        strrmp = strmid(str,i,i+len1)
        if( strrmp == str1 )
        {
            times = times + 1
            if( times >= n )
            {
                return i+1;
            }
        }
        i = i + 1;
    }

    return -1;
}
//���� str1��n�γ��ֵ�λ�ã�����
macro strrstr(str,str1,n)
{
    len = strlen(str)
    len1 = strlen(str1)
    i = len - len1

    times = 0
    while( i >= 0 )
    {
        strrmp = strmid(str,i,i+len1)
        if( strrmp == str1 )
        {
            times = times + 1
            if( times >= n )
            {
                return i+1;
            }
        }
        i = i - 1;
    }

    return -1;
}
macro Space(n)
{
    str = ""
    index = 0
    while( index < n )
    {
        str = str # " "
        index = index + 1
    }
    return str
}
macro strreplace(str, old,new)
{
    len = strlen(str)
    i = 0
    while( i < len )
    {
        if( str[i] == old )
        {
            str[i] = new
        }
        i = i + 1
    }

    return str
}

macro TrimString(szLine)
{
    szLine = TrimLeft(szLine)
    szLIne = TrimRight(szLine)
    return szLine
}

macro TrimLeft(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = 0
    while( nIdx < nLen )
    {
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
        nIdx = nIdx + 1
    }
    return strmid(szLine,nIdx,nLen)
}
macro TrimRight(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = nLen
    while( nIdx > 0 )
    {
        nIdx = nIdx - 1
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
    }
    return strmid(szLine,0,nIdx+1)
}
macro GetLeftWord(ich, sz)
{
    wordinfo = "" // create a "wordinfo" structure
    
    chTab = CharFromAscii(9)
    
    // scan backwords over white space, if any
    ich = ich - 1;
    if (ich >= 0)
        while (sz[ich] == " " || sz[ich] == chTab)
        {
            ich = ich - 1;
            if (ich < 0)
                break;
        }
    
    // scan backwords to start of word    
    ichLim = ich + 1;
    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    while (ich >= 0)
    {
        ch = toupper(sz[ich])
        asciiCh = AsciiFromChar(ch)

        //ֻ��ȡ�ַ���# { / *��Ϊ����
        if ((asciiCh < asciiA || asciiCh > asciiZ) 
           && !IsNumber(ch)
           && ( ch != "#" && ch != "{" && ch != "/" && ch != "*"))
            break;

        ich = ich - 1;
    }
    
    ich = ich + 1
    wordinfo.key = strmid(sz, ich, ichLim)
    wordinfo.ich = ich
    wordinfo.ichLim = ichLim;
    
    return wordinfo
}
//
macro GetLeftNoBlank(ich, linebuf)
{
    chTab = CharFromAscii(9)
    while (ich > 0)
    {
        ich = ich - 1;
        if (linebuf[ich] == " " || linebuf[ich] == chTab)
        {
            continue
        }
        else
        {
            break
        }
    }

    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    ch = toupper(linebuf[ich])
    asciiCh = AsciiFromChar(ch)
    symbol = ""
    if( asciiCh < asciiA || asciiCh > asciiZ )
    {
        //�Ƿ��ţ�ֱ���˳�
        symbol.name = linebuf[ich]
        symbol.ichFirst = ich
        return symbol
    }

    //��������
    ichLim = ich + 1
    while (ich >= 0)
    {
        ch = toupper(linebuf[ich])
        asciiCh = AsciiFromChar(ch)

        //������ĸ���˳�
        if (asciiCh < asciiA || asciiCh > asciiZ)
            break;

        ich = ich - 1;
    }
    ichFirst = ich + 1
    symbol = ""
    symbol.name = strmid(linebuf,ichFirst,ichLim)
    symbol.ichFirst = ichFirst
    return symbol
}

macro GetRightNoBlank(ich, linebuf)
{
    chTab = CharFromAscii(9)
    len = strlen(linebuf)

    while (ich < len-1)
    {
        ich = ich + 1;
        if (linebuf[ich] == " " || linebuf[ich] == chTab)
        {
            continue
        }
        else
        {
            break
        }
    }

    symbol = ""
    if( ich == len-1 )
    {
        symbol.name = ""
        symbol.ichFirst = -1
    }
    else
    {
        //�ұ�ֻ����һ���ַ�
        symbol.name = linebuf[ich]
        symbol.ichFirst = ich
    }

    return symbol
}
macro GetBeginNoBlank(ich, linebuf)
{
    chTab = CharFromAscii(9)

    ich1 = ich
    len = strlen(linebuf)
    ich = 0
    while (ich < ich1 && ich < len)
    {
        if (linebuf[ich] == " " || linebuf[ich] == chTab)
        {
            ich = ich + 1;
            continue
        }
        else
        {
            break
        }
    }
    if( ich == ich1 )
    {
        ich = ich -1
    }
    if( ich < 0 )
    {
        ich = 0
    }

    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    ch = toupper(linebuf[ich])
    asciiCh = AsciiFromChar(ch)

    if( asciiCh < asciiA || asciiCh > asciiZ )
    {
        //�Ƿ��ţ�ֱ���˳�
        symbol = ""
        symbol.name = linebuf[ich]
        symbol.ichFirst = ich
        return symbol
    }

    //��������
    ichFirst = ich
    while ( ich <= ich1 && ich < len)
    {
        ch = toupper(linebuf[ich])
        asciiCh = AsciiFromChar(ch)

        //������ĸ���˳�
        if (asciiCh < asciiA || asciiCh > asciiZ)
            break;

        ich = ich + 1;
    }
    ichLim = ich
    symbol = ""
    symbol.name = strmid(linebuf,ichFirst,ichLim)
    symbol.ichFirst = ichFirst
    return symbol
}
macro GetBeginBlank(linebuf)
{
    ich = 0
    while (linebuf[ich] == " " || linebuf[ich] == "\t")
    {
        ich = ich + 1
    }
    lineblanks = strmid(linebuf,0,ich)
    return lineblanks
}
macro GetEndBlankPos(linebuf)
{
    ich = strlen(linebuf) - 1
    while (linebuf[ich] == " " || linebuf[ich] == "\t")
    {
        ich = ich - 1
    }
    ich = ich + 1
    return ich
}

/* Get handle of buffer with name "name", or create a new one
 * if no such buffer exists.
 */
macro GetOrCreateBuf(name)
{
    hBuf = GetBufHandle(name)
    if (hBuf == 0) {
        hBuf = NewBuf(name)
    }
    return hBuf
}

// ���û��szfileָ�����ļ���,���½�,�����,������BUFF���
macro OpenorNewBuf(szfile)
{
    hout = GetBufHandle(szfile)
    if (hout == hNil)
    {
        hout = OpenBuf(szfile)
        if (hout == hNil)
        {
            hout = NewBuf(szfile)
            NewWnd(hout)
        }
    }
    return hout
}
macro ReloadSnippets()
{
    snipfile = LoadSnippets("DahuaAPP.Snippets")
    CloseBuf(snipfile.hbuf)

    // Msg(snipfile)
    LoadSnippets("DahuaAPP.Snippets")

}

macro LoadSnippets(filename)
{
    info = GetProgramEnvironmentInfo()
    dir = info.BackupDir
    dir = strmid(dir,0,strlen(dir)-6)
    dir = cat(dir,"Projects\\Base\\")
    filename = cat(dir,filename)

    hbuf = OpenorNewBuf(filename)
    var snipfile
    snipfile.hbuf = hbuf
    snipfile.linecnt = GetBufLineCount(hbuf)


    return snipfile
}

/*********************End Base Functions*********************/


/*********************Start Main Functions*********************/

//tab���Զ���ȫ����
macro tabCompletion()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    linebuf = GetBufLine(hbuf, sel.lnFirst);
    linebufLen = strlen(linebuf)

    if( sel.ichFirst != sel.ichLim || sel.lnFirst != sel.lnLast )
    {
        //ѡ��ģʽ,����4���ո�
        oldSel = sel
        line = oldSel.lnFirst
        while( line <= oldSel.lnLast )
        {
            sel.ichFirst = 0
            sel.ichLim = 0
            sel.lnFirst = line
            sel.lnLast = line
            SetWndSel(hwnd, sel)
            SetBufSelText(hbuf, "    ")
            line = line + 1
        }
        //��ԭѡ��״̬
        oldSel.ichFirst = oldSel.ichFirst + 4
        oldSel.ichLim = oldSel.ichLim + 4
        SetWndSel(hwnd, oldSel)

        stop
    }

    //��ȫģʽ
    keyinfo = GetLeftWord(sel.ichFirst, linebuf)
    // Msg(keyinfo)
    key = keyinfo.key
    // Msg(key)

    lnblanks = GetBeginBlank(linebuf)
    ln = sel.lnFirst

    //������
    if ( jumpOut(key)==true )
    {
        //���������������ŵ�
        // ����"/* code */"��
        return
    }
    else if( CompleteKeyword(key) == true )
    {
        return
    }
    else if( CompleteJson(keyinfo) == true )
    {
        return
    }
    else if( JumpNextArgs(key) == true )
    {
        return
    }
    // else if( CompleteWord() )
    // {
    //     return
    // }
    else
    {
        //
        Tab
        return
    }
}
macro GetSel(linebuf)
{
    var offset 

    pos = strstr(linebuf,",",1)
    offset.lnFirst = strmid(linebuf,0,pos-1)

    linebuf = strmid(linebuf,pos,strlen(linebuf))
    pos = strstr(linebuf,",",1)
    offset.ichFirst = strmid(linebuf,0,pos-1)

    linebuf = strmid(linebuf,pos,strlen(linebuf))
    pos = strstr(linebuf,",",1)
    offset.lnLast = strmid(linebuf,0,pos-1)

    linebuf = strmid(linebuf,pos,strlen(linebuf))
    offset.ichLim = linebuf

    return offset
}

macro GetSnippet(keyword)
{
    hwnd = GetCurrentWnd()
    oldsel = GetWndSel(hwnd)

    var snippet;
    snippet.ret = true
    snippet.key = keyword
    snippet.len = strlen(keyword)
    var sel

    snipfile = LoadSnippets("DahuaAPP.Snippets")
    hbuf = snipfile.hbuf
    linecnt = snipfile.linecnt

    index = 1
    while( index < linecnt - 1 )
    {
        linebuf = GetBufLine(hBuf,index)
        offset = GetBufLine(hBuf,index+1)
        if( linebuf != keyword )
        {
            index = index + 4 + offset
            continue
        }
        else
        {
            linebuf = GetBufLine(hBuf,index+2)
            snippet.lnFirst = index + 3
            snippet.lnLast = index + 2 + offset
            //��ȡsel
            oldsel.ichFirst = oldsel.ichFirst - snippet.len

            var offset
            offset = GetSel(linebuf)
            // Msg(offset)

            sel.lnFirst = oldsel.lnFirst + offset.lnFirst
            sel.ichFirst = oldsel.ichFirst + offset.ichFirst
            sel.lnLast = oldsel.lnFirst + offset.lnLast
            sel.ichLim = oldsel.ichFirst + offset.ichLim

            sel.fExtended=0
            sel.fRect=0
            break
        }
    }
    if( index >= linecnt - 1 )
    {
        //û��ƥ��
        snippet.ret = false
    }
    
    snippet.sel = sel
    snippet.hbuf = snipfile.hbuf

    return snippet
}

macro CompleteKeyword(key)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst);
    lnblanks = GetBeginBlank(linebuf)
    linebufLen = strlen(linebuf)
    ln = sel.lnFirst

    snippet = GetSnippet(key)
    if( snippet.ret == true )
    {
        // Msg(snippet)
        //�����һ��
        sel.ichFirst = sel.ichFirst - snippet.len
        SetWndSel(hwnd, sel)
        index = snippet.lnFirst
        linebuf = GetBufline(snippet.hbuf,index)
        SetBufSelText(hbuf, linebuf)
        

        index = index + 1
        while(index <= snippet.lnLast )
        {
            linebuf = GetBufline(snippet.hbuf,index)
            linebuf = lnblanks # linebuf
            InsBufLine(hbuf, sel.lnFirst + index - snippet.lnFirst, linebuf)
            index = index + 1
        }
        //���ѡ��
        SetWndSel(hwnd, snippet.sel)

        return true
    }

    return false
}
macro ShowCompleteWord(key)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf, ln+1)

    hwordbuf = GetOrCreateBuf("*FindAllWord*")
    maxCount = GetBufLineCount(hwordbuf)
    // Msg(maxCount)

    if( maxCount == 0 )
    {
        return false
    }
    else if( maxCount > 10 )
    {
        //�����ʾ10�н��
        maxCount = 10
    }

    //����Ƿ��� ">>>word"
    //����ʾ��
    startLine = 0
    endLine = 0
    newsel = sel
    if( linebuf == ">>>word" )
    {
        startLine = 1
        index = 1

        while( index < GetBufLineCount(hbuf) )
        {
            linebuf = GetBufLine(hbuf, ln+index)
            // Msg(linebuf)
            if( linebuf == "<<<word" )
            {
                endLine = index
                newsel.lnFirst = ln+startLine
                newsel.lnLast = ln+endLine
                newsel.ichFirst = 0
                newsel.ichLim = 7
                break
            }

            index = index + 1
        }
    }

    //ֻ��һ�н����ֱ�Ӳ�ȫ
    if( maxCount == 1 )
    {
        linebuf = GetBufLine(hwordbuf, 0)
        linebuf = TrimLeft(linebuf)
        if( linebuf == key )
        {
            //ֱ���˳�
            return false
        }

        linebuf = strmid(linebuf, strlen(key), strlen(linebuf))
        newsel.lnFirst = sel.lnFirst
        newsel.ichFirst = sel.ichFirst
        SetWndSel(hwnd,newsel)
        SetBufSelText(hbuf,linebuf # "\"]")

        return true
    }
    

    if( startLine != 0 && endLine != 0 )
    {
        SetWndSel(hwnd,newsel)
        SetBufSelText(hbuf,">>>word")
    }
    else
    {
        InsBufLine(hBuf, ln+1,">>>word")
    }

    // Msg(maxCount)
    index = 0
    while( index < maxCount )
    {
        linebuf = GetBufLine(hwordbuf, index)
        InsBufLine(hBuf, ln+2+index,linebuf)

        index = index + 1
    }

    InsBufLine(hbuf, ln+2+index, "<<<word")
    SetWndSel(hwnd, sel)

    return true
}

macro FindAll(key)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hWnd)

    hnewbuf = GetOrCreateBuf("*FindAllWord*")
    ClearBuf(hnewbuf)

    findFlag = false
    searchLine = 1
    blanks = Space(sel.ichFirst - strlen(key))
    while(1)
    {
        search = SearchInBuf(hbuf, key # "[a-zA-Z0-9_]*", searchLine,0,1,1,0)
        // Msg(search)
        if( search == "" )
        {
            break
        }
        if( search.lnFirst != sel.lnFirst )
        {
            linebuf = GetBufline(hbuf, search.lnFirst)
            word = strmid(linebuf, search.ichFirst, search.ichLim)
            // Msg(word)

            //ȥ��append
            if( SearchInBuf(hnewbuf, word, 0,0,1,0,1) == "" )
            {
                // Msg(word)
                AppendBufLine(hnewbuf, blanks # word)
            }

            findFlag = true
        }
        searchLine = search.lnFirst + 1
    }
    // Msg("finish")
    return findFlag
}

macro CompleteJson(keyinfo)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)

    // Msg(keyinfo)
    if( keyinfo.ich <= 2 || keyinfo.key == "" )
    {
        return false
    }
    // �������json�ֶ�
    if( linebuf[keyinfo.ich-1] != "\"" || linebuf[keyinfo.ich-2] != "[" )
    {
        return false
    }

    if( FindAll(keyinfo.key) == true )
    {
        return ShowCompleteWord(keyinfo.key)
    }

    return false
}
macro JumpNextArgs(key)
{
    if( key == "" )
    {
        return false
    }

    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst);
    linebufLen = strlen(linebuf)

    hnewbuf = GetOrCreateBuf("*Functions-Line*")
    ClearBuf(hnewbuf)
    AppendBufLine(hnewbuf, linebuf)

    //�жϵ�ǰ���Ƿ��Ǻ�������
    isfunc = SearchInBuf(hnewbuf, "[a-zA-Z_0-9]+\\s+[a-zA-Z_0-9]+(.*)", 0, 0,0,1,0)
    // Msg(isfunc)
    if( isfunc != "" )
    {
        return false
    }
    // isfunc = SearchInBuf(hnewbuf, "[(\\.)|(->)]*[a-zA-Z_0-9]+([a-zA-Z_0-9\\s,\\*/=->\\.]*)", 0, 0,0,1,0)
    isfunc = SearchInBuf(hnewbuf, "[a-zA-Z_0-9]+(.*)", 0, 0,0,1,0)
    // Msg(isfunc)

    //���Ǻ�������
    if( isfunc == "" )
        return false
    if( linebuf[isfunc.ichFirst-1] == ":" )
        return false


    //�Ҳ���
    result = SearchInBuf(hnewbuf,"[a-zA-Z_0-9]+\\s+[\\*|&]*\\s*[a-zA-Z_0-9]+\\s*=*\\s*[a-zA-Z_0-9]*", 0, sel.ichFirst+1,0,1,0)

    // Msg(result)
    if( result != "" )
    {
        //ѡ�в���
        result.ichFirst = result.ichFirst
        result.ichLim = result.ichLim
        result.lnFirst = sel.lnFirst
        result.lnLast = sel.lnLast
        SetWndSel(hWnd,result)
        return true
    }

    return false
}

macro BackspaceEx()
{
    hwnd = GetCurrentWnd()
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)
    linebuf = GetBufLine(hbuf, sel.lnFirst)

    if( sel.fExtended == 1 || sel.ichFirst == 0 || sel.ichFirst == strlen(linebuf) )
    {
        //ɾ������ַ�
        Backspace
        Stop
    }


    a = linebuf[sel.ichFirst-1]
    b = linebuf[sel.ichFirst]
    c = linebuf[sel.ichFirst+1]

    //ƥ����Ŷ�
    symbols = "\"\"''()<>{}[]"
    len = strlen(symbols)
    index = 0
    while( index < len )
    {
        if( a == symbols[index] )
        {
            Backspace
            if( b == symbols[index+1])
                Delete_Character
            else if( b == " " && c == symbols[index+1] )
            {
                Delete_Character
                Delete_Character
            }

            Stop
        }
        index = index + 2
    }

    //ɾ��һ���ַ�
    Backspace
}
macro jumpOut(key)
{
    hwnd = GetCurrentWnd()
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst)
    linebufLen = strlen(linebuf)
    ichFirst = sel.ichFirst;

    if( ichFirst <= 0 )
    {
        return false
    }

    //�ȴ�����ת
    if( linebuf[ichFirst-1] == ")" && sel.lnFirst + 3 < GetBufLineCount(hbuf) )
    {
        ln = sel.lnFirst
        lnblanks = GetBeginBlank(linebuf)

        linecur = GetBufLine(hbuf, ln);
        line1 = GetBufLine(hbuf, ln+1);
        line2 = GetBufLine(hbuf, ln+2);
        line3 = GetBufLine(hbuf, ln+3);

        szLine1 = lnblanks # "{"
        szLine2 = lnblanks # "    /* code */"
        szLine3 = lnblanks # "}"

        sel.ichFirst = strlen(lnblanks) + 4
        if( line1 == szLine1 && line2 == szLine2 && line3 == szLine3 )
        {
            sel.ichLim = sel.ichFirst + 10
        }
        else if( line1 == szLine1 )
        {
            sel.ichLim = sel.ichFirst
        }

        sel.lnFirst = ln + 2
        sel.lnLast = sel.lnFirst
        SetWndSel(hwnd, sel)
        return true
    }

    //jumpOut��������
    if( sel.ichFirst == linebufLen && sel.lnFirst + 4 < GetBufLineCount(hbuf) )
    {
        //����β����ת��code��
        line = sel.lnFirst + 1
        while( line <= sel.lnFirst + 2 )
        {
            linebuf = GetBufLine(hbuf, line)
            pos = strstr(linebuf,"* code *",1)
            if( pos != -1 )
            {
                sel.ichFirst = pos - 2
                sel.ichLim = pos + 8
                sel.lnFirst = line
                sel.lnLast = line
                SetWndSel(hwnd,sel)

                return true
            }
            line = line + 1
        }
    }
    else
    {
        //����ð�������ŵ�����
        right = strmid(linebuf,ichFirst,linebufLen)
        gothere = 0
        if( right == "\");" || right == ")" )
        {
            gothere = 1;
        }
        else if( right == ");" || right == " )" )
        {
            gothere = 2;
        }

        if( gothere != 0 )
        {
            sel.ichFirst = sel.ichFirst + gothere
            sel.ichLim = sel.ichFirst
            SetWndSel(hwnd,sel) 
            return true
        }
    }
    return false
}

//��ת������ Ctrl + a
macro jumpLineStart()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    
    linebuf = GetBufLine(hbuf, sel.lnFirst);
    right = TrimLeft(linebuf)
    pos = strlen(linebuf) - strlen(right)
    //�����ǰλ����������ˣ�������0
    if( pos == sel.ichFirst )
        pos = 0

    sel.ichFirst = pos
    sel.ichLim = pos
    SetWndSel(hwnd, sel)
}

//��ת����β Ctrl + e
macro jumpLineEnd()
{
   hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)

    linebuf = GetBufLine(hbuf, sel.lnFirst);
    left = TrimRight(linebuf)
    pos = strlen(left)
    //�����ǰλ����������ˣ�������0
    if( pos == sel.ichFirst )
        pos = strlen(linebuf)

    sel.ichFirst = pos
    sel.ichLim = pos
    SetWndSel(hwnd, sel)
}
macro IsWord(ch)
{
    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    ch = toupper(ch)
    asciiCh = AsciiFromChar(ch)

    if( asciiCh >= asciiA && asciiCh <= asciiZ )
    {
        return true
    }
    else
    {
        return false
    }
}
macro IsSymbol(ch)
{
    if( IsWord(ch) == true || ch == "_" || IsNumber(ch) )
    {
        return true
    }
    else
    {
        return false
    }
}
macro GoLeft()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    linebuf = GetBufLine(hbuf,sel.lnFirst)
    ichFirst = sel.ichFirst
    lnFirst = sel.lnFirst

    ichFirst = ichFirst - 1
    if( ichFirst < 0 )
    {
        lnFirst = lnFirst - 1
        if(lnFirst < 0)
        {
            ichFirst = 0
            lnFirst = 0
        }
        else
        {
            linebuf = GetBufLine(hbuf,lnFirst)
            ichFirst = strlen(linebuf)
        }

        sel.ichFirst = ichFirst
        sel.ichLim = ichFirst
        sel.lnFirst = lnFirst
        sel.lnLast = lnFirst
        SetWndSel(hwnd, sel)
        return
    }
    hasword = false
    while( ichFirst >= 0 )
    {
        ch = linebuf[ichFirst]

        if( hasword == false && IsSymbol(ch) == false )
        {
            ichFirst = ichFirst - 1
        }
        else if( IsSymbol(ch) )
        {
            hasword = true
            ichFirst = ichFirst - 1
        }
        else
        {
            break
        }
    }
    if( hasword == true )
    {
        ichFirst = ichFirst + 1
    }
    sel.ichFirst = ichFirst
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}
macro GoRight()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    linebuf = GetBufLine(hbuf,sel.lnFirst)
    len = strlen(linebuf)
    maxline = GetBufLineCount(hbuf)
    ichFirst = sel.ichFirst
    lnFirst = sel.lnFirst

    ichFirst = ichFirst + 1
    if( ichFirst > len )
    {
        lnFirst = lnFirst + 1
        if(lnFirst > maxline)
        {
            ichFirst = len
            lnFirst = maxline
        }
        else
        {
            ichFirst = 0
        }

        sel.ichFirst = ichFirst
        sel.ichLim = ichFirst
        sel.lnFirst = lnFirst
        sel.lnLast = lnFirst
        SetWndSel(hwnd, sel)
        return
    }
    hasword = false
    while( ichFirst < len )
    {
        ch = linebuf[ichFirst]

        if( hasword == false && IsSymbol(ch) == false )
        {
            ichFirst = ichFirst + 1
        }
        else if( IsSymbol(ch) )
        {
            hasword = true
            ichFirst = ichFirst + 1
        }
        else
        {
            break
        }
    }
    sel.ichFirst = ichFirst
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}
macro GoUp5()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    sel.lnFirst = sel.lnFirst - 5
    if( sel.lnFirst < 0 )
    {
        sel.lnFirst = 0
    }
    sel.lnLast = sel.lnFirst
    topline = GetWndVertScroll(hwnd)
    SetWndSel(hwnd,sel)
    ScrollWndToLine(hwnd,topline-5)
}
macro GoDown5()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    lnFirst = sel.lnFirst

    lnFirst = lnFirst + 5
    if( lnFirst >= GetBufLineCount(hbuf) )
    {
        lnFirst = GetBufLineCount(hbuf) - 1
    }
    topline = GetWndVertScroll(hwnd)
    if topline + GetWndLineCount(hwnd) < GetBufLineCount(hbuf)
        ScrollWndToLine(hwnd,topline + 5)

    sel.lnFirst = lnFirst
    sel.lnLast = sel.lnFirst
    SetWndSel(hwnd,sel)
}

////////////////////////////////////////////////////////
//////////////////////// VimMode ///////////////////////
macro VimMode()
{
    hbuf = GetCurrentBuf();
    mode = "Cursor"

    while(1)
    {
        // Wait for the next key press and return the key code.
        key = GetKey()
        
        // Map the key code into a simple character.
        //
        // If you only need a simple character, you can 
        // call GetChar() instead of GetKey + CharFromKey
        ch = CharFromKey(key)
        //����ƶ�
        if( MoveCursor(ch, mode) == true )
            continue
        else if( ch == "v" )
        {
            if( mode == "Cursor" )
                mode = "Select"
            else
                mode = "Cursor"
        }
        else if( ch == "-" )
            Jump_To_Prototype
        else if( ch == "=" )
            JumpToDefinitionEx
        else if( ch == "p" )
            Page_Up
        else if( ch == "n" )
            Page_Down
        else if( ch == "f" )
            FindInLine
        else if( ch == "c" )
            show_at_center
        else if( ch == "q" ) //q�˳�vimģʽ
            stop
    }
}
macro FindInLine()
{
    hWnd = GetCurrentWnd()
    sel = GetWndSel(hWnd)

    hbuf = GetCurrentBuf();
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)

    key = GetKey()
    ch = CharFromKey(key)
    ch = toupper(ch)

    index = sel.ichFirst + 1
    len = strlen(linebuf)
    while( index < len )
    {
        if( toupper(linebuf[index]) == ch )
            break

        index = index + 1
    }

    if( index < len )
    {
        sel.ichFirst = index
        sel.ichLim = sel.ichFirst
        SetWndSel(hWnd, sel)
    }
}
macro show_at_center()
{
    hWnd = GetCurrentWnd()
    sel = GetWndSel(hWnd)
    hbuf = GetCurrentBuf()

    topline = GetWndVertScroll(hwnd)
    linecount = GetWndLineCount(hwnd)
    buflinecount = GetBufLineCount(hBuf)

    offset = linecount/2 - (sel.lnFirst - topline)
    dstline = topline-offset

    if( dstline > 0 && dstline < buflinecount - linecount + 1 )
        ScrollWndToLine(hwnd,dstline)
}
macro MoveCursor(ch, mode)
{
    if( ch == "h" && mode == "Cursor" )
        Cursor_Left
    else if( ch == "h" && mode == "Select" )
        Select_Char_Left
    else if( ch == "j" && mode == "Cursor" )
        Cursor_Down
    else if( ch == "j" && mode == "Select" )
        Select_Line_Down
    else if( ch == "k" && mode == "Cursor" )
        Cursor_Up
    else if( ch == "k" && mode == "Select" )
        Select_Line_Up
    else if( ch == "l" && mode == "Cursor" )
        Cursor_Right
    else if( ch == "l" && mode == "Select" )
        Select_Char_Right
    else if( ch == "a" )
        jumpLineStart
    else if( ch == "e" )
        jumpLineEnd
    else
        return false

    return true
}
//////////////////////// VimMode End///////////////////////
////////////////////////////////////////////////////////


macro InsertPoint()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    SetBufSelText(hbuf, "tracepoint();");

    linebuf = GetBufLine(hbuf,sel.lnFirst)
    lnblanks = GetBeginBlank(linebuf)
    InsBufLine(hbuf, sel.lnFirst + 1, lnblanks);
    sel.lnFirst = sel.lnFirst + 1
    sel.lnLast = sel.lnFirst
    SetWndSel(hwnd, sel)
}
macro InsertFuncName()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop

    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    symbolname = GetCurSymbol()
    index = 0
    len = strlen(symbolname)
    while( index < len )
    {
        if( symbolname[index] == "." )
            break
        index = index + 1
    }
    if( index == len)
    {
        str = "trace(\"" # symbolname # ">>> \\n\");"
    }
    else
    {
        classname = strmid(symbolname,0,index)
        funcname = strmid(symbolname,index+1,len)
        str = "trace(\"" # classname # "::" # funcname # ">>> \\n\");"
    }
    SetBufSelText(hbuf, str)
    sel.ichFirst = sel.ichFirst + strlen(str) - 5
    sel.ichLim = sel.ichFirst
    SetWndSel(hwnd, sel)
}

//����ע����ȥע�͹���
macro MultiLineComment()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    lnFirst = GetWndSelLnFirst(hwnd)      //ȡ�����к�
    lnLast = GetWndSelLnLast(hwnd)      //ȡĩ���к�
    ichFirst = sel.ichFirst
    ichLim = sel.ichLim
    hbuf = GetCurrentBuf()

    isComment = true      //Ĭ��ע�͹�

    //�ȼ���Ƿ���ע�͹�
    line = lnFirst
    while( line <= lnLast )
    {
        linebuf = GetBufLine(hbuf,line)
        lineLen = strlen(linebuf)

        szRight = TrimLeft(linebuf)
        rightLen = strlen(szRight)
        if(  rightLen < 2 )
        {
            isComment = false
            break
        }

        if( strmid(szRight,0,2) == "//" )
        {
            line = line + 1
            continue
        }
        else
        {
            isComment = false
            break
        }
    }

    if( isComment )
    {
        //ȥ��ע��
        line = lnFirst
        lnFirstPos = 2 //��һ��������2��
        while(line <= lnLast)
        {
            linebuf = GetBufLine(hbuf,line)
            lineLen = strlen(linebuf)
            szRight = TrimLeft(linebuf)
            rightLen = strlen(szRight)

            leftLen = lineLen - rightLen
            pos = leftLen + 2
            newbuf = ""
            if( rightLen > 2 && szRight[2] == " ")
            {
                pos = pos + 1
                if( line == lnFirst )
                    lnFirstPos = lnFirstPos + 1
            }
            if( leftLen > 0 )
                newbuf = newbuf # strmid(linebuf, 0,leftLen)
            newbuf = newbuf # strmid(linebuf, pos,lineLen)
            DelBufLine(hbuf,line)
            InsBufLine(hbuf,line,newbuf)

            line = line + 1
        }
        sel.ichFirst = ichFirst - lnFirstPos
        sel.ichLim = ichLim - lnFirstPos
        SetWndSel(hwnd, sel)
    }
    else
    {
        //����ע��

        //��������ߵķǿ��ַ�
        minFirst = 9999
        line = Lnfirst
        while( line <= lnLast )
        {
            linebuf = GetBufLine(hbuf,line)
            lineLen = strlen(linebuf)
            szRight = TrimLeft(linebuf)
            rightLen = strlen(szRight)
            if( rightLen == 0 )   //���в�����
            {
                minFirst = 0
                break
            }
            if( lineLen - rightLen < minFirst )
            {
                minFirst = lineLen - rightLen
            }
            line = line + 1
        }
        //����ע��"// "
        line = lnFirst
        while( line <= lnLast )
        {
            linebuf = GetBufLine(hbuf,line)

            sel.ichFirst = minFirst
            sel.ichLim = minFirst
            sel.lnFirst = line
            sel.lnLast = line
            SetWndSel(hwnd, sel)
            SetBufSelText(hbuf, "// ")

            line = line + 1
        }
        sel.ichFirst = ichFirst + 3
        sel.ichLim = ichLim + 3
        sel.lnFirst = lnFirst
        sel.lnLast = lnLast
        SetWndSel(hwnd, sel)
    }
}

macro blame()
{
  filename = GetBufName (GetCurrentBuf ())
  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("cmd /C \"TortoiseProc.exe /command:blame /path:\"",filename),"\"\"")
  RunCmdLine (cmdline, path, 0);
}

macro diff()
{

  filename = GetBufName (GetCurrentBuf ())
  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("cmd /C \"TortoiseProc.exe /command:diff /path:\"",filename),"\"\"")
  //cmdline = cat(cat("TortoiseProc.exe /command:diff /path:\"",filename),"\"")
  RunCmdLine (cmdline, path, 0);
}

macro log()
{
  filename = GetBufName (GetCurrentBuf ())

  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("cmd /C \"TortoiseProc.exe /command:log /path:\"",filename),"\"\"")
  //cmdline = cat(cat("TortoiseProc.exe /command:diff /path:\"",filename),"\"")
  RunCmdLine (cmdline, path, 0);
}

macro explorer()
{
  filename = GetBufName (GetCurrentBuf ())
  path = strmid(filename,0,getFileName(filename));
  cmdline = cat(cat("explorer /select,\"",filename),"\"");
  RunCmdLine (cmdline, path, 0);
}
macro RunExe()
{

}
macro JumpToFile(filename)
{
    ifile = 0
    hproj = GetCurrentProj()
    ifileMax = GetProjFileCount (hproj)
    while (ifile < ifileMax )
    {
        file1 = GetProjFileName (hproj, ifile)
        // Msg(file1)

        len1 = strlen(file1)
        len = strlen(filename)
        
        if( len1 < len )
        {    
            ifile = ifile + 1
            continue
        }
        if( strmid(file1,len1-len,len1) == filename )
        {
            break
        }
        ifile = ifile + 1
    }

    if( ifile < ifileMax )
    {
        fbuf = OpenBuf(file1)
        SetCurrentBuf(fbuf)
    }
}
macro JumpCpp()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    bufname = GetBufName(hbuf)
    pos = strrstr(bufname,"\\",2)
    //û���ҵ�����ȡȫ���ַ���
    if( pos == -1 )
    {
        pos = 0
    }

    filename = strmid(bufname,pos,strlen(bufname))
    len = strlen(filename)

    if( filename[len-2] == "." && filename[len-1] == "h" )
    {
        dstfile = strmid(filename,0,len-1) # "cpp"
    }
    else
    {
        dstfile = strmid(filename,0,len-3) # "h"
    }

    JumpToFile(dstfile)
}

///\brief ��Ӻ���Doxygenע��
///\param ��
///\return ��
macro AddFuncDoc()
{
    // Get a handle to the current file buffer and the name
    // and location of the current symbol where the cursor is.
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    blanks = GetBeginBlank(buf)
    InsBufLine( hbuf, ln, blanks # "/**" )
    InsBufLine( hbuf, ln + 1, blanks # " * \@brief " )
    InsBufLine( hbuf, ln + 2, blanks # " * \@param " )
    InsBufLine( hbuf, ln + 3, blanks # " * \@return " )
    InsBufLine( hbuf, ln + 4, blanks # " */" )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, ln+1, strlen(blanks) + 10 )
}

macro AddDetailDoc()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    blanks = GetBeginBlank(buf)
    ln = ln + 1;InsBufLine( hbuf, ln, blanks # "//! " )
    line = ln
    ln = ln + 1;InsBufLine( hbuf, ln, "" )
    ln = ln + 1;InsBufLine( hbuf, ln, blanks # "//! " )
    ln = ln + 1;InsBufLine( hbuf, ln, blanks # "//! " )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, line, strlen(blanks) + 4 )
}
macro AddBreifDoc()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    blanks = GetBeginBlank(buf)
    InsBufLine( hbuf, ln, blanks # "//! " )
 
    // put the insertion point inside the header comment
    SetBufIns( hbuf, ln, strlen(blanks) + 4 )
}
macro AddMemberDoc()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )

    buf = GetBufLine(hbuf,ln)
    pos = GetEndBlankPos(buf) + 1

    sel.ichFirst = pos
    sel.ichLim = pos
    SetWndSel(hwnd, sel)
    //SetBufSelText(hbuf, "/**<  */")
    SetBufSelText(hbuf, "///< ")
    SetBufIns( hbuf, ln, pos + 5 )
}
macro AddFileHeaderDoc()
{
    hbuf = GetCurrentBuf()
    ln = 0
    InsBufLine( hbuf, ln,    "/*" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  ********************************************************************************")
    ln = ln + 1;InsBufLine( hbuf, ln,    " *                                     Challenger" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *                          Digital Video Recoder xp" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *   (c) Copyright 1992-2004, ZheJiang Dahua Information Technology Stock CO.LTD." )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *                            All Rights Reserved" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  File        : Challenger.cpp" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  Description : " )
    line = ln
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  Create      : 2005/3/9      WHF     Create the file" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " *  ********************************************************************************" )
    ln = ln + 1;InsBufLine( hbuf, ln,    " */" )
    ln = ln + 1;InsBufLine( hbuf, ln,    "" )

    // put the insertion point inside the header comment
    SetBufIns( hbuf, line, 20 )
}

/*   C L O S E _   O T H E R S _   W I N D O W S   */
/*-------------------------------------------------------------------------
    Close all but the current window.  Leaves any other dirty 
    file windows open too.
-------------------------------------------------------------------------*/
macro Close_Others_Windows()
{
    hCur = GetCurrentWnd();
    hNext = GetNextWnd(hCur);
    while (hNext != 0 && hCur != hNext)
    {
        hT = GetNextWnd(hNext);
        hbuf = GetWndBuf(hNext);
        if (!IsBufDirty(hbuf))
            CloseBuf(hbuf)
        hNext = hT;
    }
}

/**
 * @brief ѡ�и���
 * @details [long description]
 * @return [description]
 */
macro CopyWord_Str()
{
    hwnd = GetCurrentWnd()
    Sel = GetWndSel(hwnd)

    //ѡ�񵥴ʻ����ַ���
    if( Sel.fExtended == false )
    {
        Select_Word
    }
    else
    {
        hbuf = GetCurrentBuf()
        ln = GetBufLnCur( hbuf )
        linebuf = GetBufLine(hbuf,ln)
        len = strlen(linebuf)

        if( Sel.ichFirst == 0 || Sel.ichLim == len )
        {
            return
        }
        else if( linebuf[Sel.ichFirst-1] == "\"" && linebuf[Sel.ichLim+1] == "\"" )
        {
            return
        }
        else
        {
            // left = strmid(linebuf,0,Sel.ichFirst)
            // leftPos = -1
            // while( left != "" )
            // {
            //     leftPos = strrstr(left,"\"", 1)
            //     if( leftPos == 0 )
            //         break
            //     else if( left[leftPos-1] == "\\" )
            //     {
            //         left = strmid(left,0,leftPos)
            //         leftPos = -1
            //     }
            //     else
            //         break
            // }
            // right = strmid(linebuf, Sel.ichLim, len)
            // rightPos = -1
            // while( right != "" )
            // {
            //     rightPos = strstr(right,"\"", 1)
            //     if( leftPos == 0 )
            //         break
            //     else if( right[rightPos+1] == "\\" )
            //     {
            //         right = strmid(right,rightPos,strlen(right))
            //         rightPos = -1
            //     }
            //     else
            //         break
            // }
            left = strmid(linebuf,0,Sel.ichFirst)
            leftPos = strrstr(left,"\"", 1)
            right = strmid(linebuf, Sel.ichLim, len)
            rightPos = strstr(right,"\"", 1)
            if( leftPos != -1 && rightPos != -1 )
            {
                Sel.ichFirst = leftPos
                Sel.ichLim = Sel.ichLim + rightPos - 1
                SetWndSel(hwnd,Sel)
            }
        }
    }
    //����
    Copy
}
macro CopyLine_ToNext()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    ichFirst = sel.ichFirst

    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)

    InsBufLine (hbuf, ln+1, linebuf);
    
    sel.lnFirst = ln+1
    sel.lnLast = sel.lnFirst
    SetWndSel(hwnd,sel)
}

macro Delword_or_Copy()
{
    Select_Word
    Paste
}

macro OpenBaseProj()
{
    OpenProj("\\\\10.30.21.200\\UserDesktop01\\17417\\MyDoc\\Source Insight\\Projects\\Base\\Base")
}


macro JumpBlock()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur( hbuf )
    linebuf = GetBufLine(hbuf,ln)
    len = strlen(linebuf)

    // Msg(linebuf)

    if( sel.ichFirst < len && linebuf[sel.ichFirst] != "}" )
    {
        Block_Down
    }
    else
    {
        Block_Up
    }
}
macro SelectBlockEx()
{
    Select_Block
}
macro CopyPrevFilePath()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    hNext = GetNextWnd(hwnd)
    nextBuf = GetWndBuf(hNext)
    nextbufName = GetBufName(nextBuf)

    bufname = strreplace(nextbufName,"\\", "/")
    // Msg(bufname)

    pos = strrstr(bufname,"Dahua3.0",1)
    if( pos != -1 )
    {
        filepath = strmid(bufname,pos+8,strlen(bufname))
        // Msg(filepath)
        SetBufSelText(hbuf, filepath)
        return
    }

    pos = strrstr(bufname,"HeadFiles",1)
    if( pos != -1 )
    {
        filepath = strmid(bufname,pos+9,strlen(bufname))
        // Msg(filepath)
        SetBufSelText(hbuf, filepath)
        return
    }

    //
    pos = strrstr(bufname,"Include",1)
    if( pos != -1 )
    {
        filepath = strmid(bufname,pos+7,strlen(bufname))
        // Msg(filepath)
        SetBufSelText(hbuf, filepath)
        return
    }

    SetBufSelText(hbuf,bufname)
}

//������ת������֧��ͷ�ļ���ת
macro JumpToDefinitionEx()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    linebuf = GetBufLine(hbuf,sel.lnFirst)
    
    //���ȴ���ͷ�ļ���ת
    key = "#include"
    len = strlen(key)
    linebuf = TrimLeft(linebuf) //��߿ո�ȥ��

    if( len < strlen(linebuf) )
    {
        if( strmid(linebuf,0,len) == key )
        {
            pos1 = strstr(linebuf,"\"",1)
            pos2 = strstr(linebuf,"\"",2)
            if( pos1 != -1 && pos2 != -1 )
            {
                dstfile = strmid(linebuf,pos1, pos2-1)
                dstfile = strreplace(dstfile,"/", "\\")
                // Msg(dstfile)
                JumpToFile(dstfile)
            }
            //��
            return
        }
    }

    //��Ĭ�Ϸ�ʽ���������ת
    Jump_To_Definition
}

/*********************End Main Functions*********************/


/*********************Start Set Macro Functions*********************/
macro setEnvironment()
{
        //�汾�ж�,3.5065���³���֧��
        ProVer = GetProgramInfo ();
        if(ProVer.versionMinor < 50 || ProVer.versionBuild < 60)
        {
            // Msg("����Source Insight�汾̫�ͣ�����ʹ�ô˹��ߣ��밲װ3.50.0060�����ϰ档");
            // stop
        }
        
        initGlobal();//��ʼ��ȫ�ֱ���
        
        hProj = GetCurrentProj ();
        dir_proj = GetProjDir (hProj);
        //Ѱ�Ҵ���Ŀ¼
        depend_file = cat(dir_proj, "\\Build\\depend");
        
        //depend�ļ�������,˵�������source insight���̲���һ���ļ��У���ѯ��
        if(0 == ifExist(depend_file) )
        {   
            dir_proj = searchDir();
        }
        
        if(-1 == dir_proj )
        {
            dir_proj = Ask("�����뵱ǰ���̵Ĵ���Ŀ¼����'D:\\Code\\P_2011.05.04_XQ_2.608'");
        }

        if(strmid(dir_proj, strlen(dir_proj) - 1, strlen(dir_proj)) == "\\")
        {
            dir_proj = strmid(dir_proj, 0, strlen(dir_proj) - 1);
        }
                
        //��depend�ļ�д������     
        depend_file = cat(dir_proj, "\\Build\\depend");
        cmd_count = writeMakeFile(depend_file)
        
        //��depend_ti�ļ�д������
        depend_file = cat(dir_proj, "\\Build\\depend_ti");
        writeMakeFile(depend_file)

        //modiFile();
        
        Msg("�������ı���·�������������������check��������:make OEM_VENDOR=HoneyWell check");

        //�򹤳���ӻ�������

        con_file = cat(dir_proj, "\\defined.all");
        setCondition(hProj, con_file);
                
        con_file = cat(dir_proj, "\\defined");
        setCondition(hProj, con_file);
        
        //��depend�ļ������linux����
        depend_file = cat(dir_proj, "\\Build\\depend");
        restoreMakeFile(depend_file);

        depend_file = cat(dir_proj, "\\Build\\depend_ti");
        restoreMakeFile(depend_file);

        con_file = cat(dir_proj, "\\defined");
        if(0 != ifExist(con_file))
        {
            SyncProjEx (hProj, 0, 1, 0);
                        
            Msg("���������Ѿ��趨��");           
        }
        else
        {
            Msg("δ��⵽��ʱ�ļ�defined��defined.all�Ƿ����·������?");
        }   
}

macro clearEnvironment()
{
    //�汾�ж�,3.5065���³���֧��
    ProVer = GetProgramInfo ();
    if(ProVer.versionMinor < 50 || ProVer.versionBuild < 60)
    {
        // Msg("����Source Insight�汾̫�ͣ�����ʹ�ô˹��ߣ��밲װ3.50.0060�����ϰ档");
        // stop
    }

    hProj = GetCurrentProj ();
    dir_proj = GetProjDir (hProj);

        //Ѱ�Ҵ���Ŀ¼
    depend_file = cat(dir_proj, "\\Build\\depend");
    
    //depend�ļ�������,˵�������source insight���̲���һ���ļ��У���ѯ��
    if(0 == ifExist(depend_file) )
    {   
        dir_proj = searchDir();
    }
    
    if(-1 == dir_proj )
    {
        dir_proj = Ask("�����뵱ǰ���̵Ĵ���Ŀ¼����'D:\\Code\\P_2011.05.04_XQ_2.608'");
    }

    if(strmid(dir_proj, strlen(dir_proj) - 1, strlen(dir_proj)) == "\\")
    {
        dir_proj = strmid(dir_proj, 0, strlen(dir_proj) - 1);
    }
    
    //���ݺ����б��ļ�,����Ѿ����ڵĻ�������
    con_file = cat(dir_proj, "\\defined.all");
    clearCondition(hProj,con_file);

    con_file = cat(dir_proj, "\\defined");
    clearCondition(hProj,con_file);

    SyncProjEx (hProj, 0, 1, 0);
    
    //�����м��ļ�,������´β�������,������clsList����������������          
    com_str = cat("cmd /C \"del ",cat(dir_proj, "\\defined.all\""));
    RunCmdLine (com_str, dir_proj, 1);      
    
    com_str = cat("cmd /C \"del ",cat(dir_proj, "\\defined\""));
    RunCmdLine (com_str, dir_proj, 1);

    Msg("������������еĺ�!");  
}

//ȡ�е�����,����ȡ"-Dversion=2.6"�е�"version"
macro nameOf(str)
{
    pos=0;
    while(pos<strlen (str))
    {
        if(strmid (str,pos, pos+1) == "=")
            break;
        pos = pos + 1;
    }
    if(strlen(str) <= 2)
    {
        return strmid (str,0,pos);
    }
    else if(strmid (str,0,2) == "-D" || strmid (str,0,2) == "-U" )
    {
        return strmid (str,2,pos);
    }
    else
    {
        return strmid (str,0,pos);
    }
}

//ȡ��ʽ��ֵ,����ȡ"-Dversion=2.6"�е�"2.6"
macro valueOf(str)
{
    pos=0;
    while(pos<strlen (str))
    {
        if(strmid (str,pos, pos+1) == "=")
            break;
        pos = pos + 1;
    }

    if(strlen(str) <= 2)
    {
        return 0;
    }
    else if(strmid (str,0,2) == "-D" && strlen(str) == pos)
    {
        return 1;
    }
    else if(strmid (str,0,2) == "-D" && strlen(str) != pos)
    {
        return strmid (str,pos+1,strlen (str));
    }
    else
    {
        return 0;
    }
}

//�ж��ļ��Ƿ����,0��������,1�������
macro ifExist(file)
{
    hbuf = OpenBuf(file);
    if(0 == hbuf )
    {
        return 0;
    }
    else
    {
        CloseBuf(hbuf);
        return 1;
    }
}

//�����ض��������ļ��е������
macro lineOfFile(file, str)
{
    if(0 == ifExist(file))
    {
        return 0;
    }
    else
    {
        hbuf = OpenBuf (file);
        ln_cnt = GetBufLineCount(hbuf);
        ln = 0; 
        while(ln<ln_cnt)
        {
            if(str == GetBufLine (hbuf, ln))
                return ln;
                
            ln = ln + 1;
        }
        CloseBuf (hbuf);        
        return 0;

    }
}

//��Ҫд��depend�ļ�������д��ϵͳ�Ļ��������
//����ȫ�ֱ���ʹ��,�����Ժ���ĳ���
macro initGlobal()
{
    PutEnv("cmd_count", "5");//��Ҫ�������������

    putEnv("cmd_str0","check:");    
    putEnv("cmd_str1","\t-\@echo 'Collecting condition variables......';find ../../ -name *.cpp -exec grep -E '^\\s*#if|^\\s*#elif' {} \\; > ../../tmp ;"); 
    putEnv("cmd_str2","\t-\@cat ../../tmp| grep -E '^\\s*#[^\\/]+' -o | sed -r 's/\\|\\||&&/\\n/g' | sed -r 's/#[a-z]+|defined|\\(|\\)|\s+|!|[0-9]*\\s*(>|<|=|<=|>=|==)\\s*[0-9]*|\\s*|\"//g' > ../../tmp1;");
    putEnv("cmd_str3","\t-\@cat ../../tmp1| sed -r '/^(0|1)?$$/d' | sort -u | sed -r 's/(.*)/-U\\1/g' > ../../defined.all");    
    putEnv("cmd_str4","\t-\@echo $(CFLAGS)|sed -r 's/(-[a-zA-Z])/\\n\\1/g' | grep -E '(-D|-U).*' -o | sed -r 's/=.*|\\s+//g' > ../../defined;rm ../../tmp*;");
} 

//���ļ���ɾ����,����ln�������Լ�֮���count��,����ɾ����������
macro restoreMakeFile(depend_file)
{
    str = GetEnv("cmd_str0");//��־����
    ln = lineOfFile(depend_file,str);
    count = GetEnv("cmd_count");// 4; 
    
    if(0 == ifExist(depend_file) || ln == 0)
    {
        return 0;
    }
    else
    {
        hbuf = OpenBuf(depend_file);
        ln  = GetBufLineCount (hbuf) ;  
        
        i = ln;
        while(i > ln - count)
        {
            DelBufLine (hbuf, i - 1);
            i = i - 1;
        }
        SaveBuf (hbuf); 

        CloseBuf(hbuf);
        return count;
    }
}

//��depend�ļ�д��linux����(������ȡ���Լ�����),���ز������������
macro writeMakeFile(depend_file)
{
    str = GetEnv("cmd_str0");//��־����
    ln = lineOfFile(depend_file,str);

    cmdLnCnt = GetEnv("cmd_count");// 4;
    if(0 == ln)//�ļ���������
    {                               
        if(0 == depend_file )
        {
            return 0;
        }
        else if(0 == ifExist(depend_file))
        {
            return 0;
        }
        else
        {           
            hbuf = OpenBuf (depend_file);           
            ln  = GetBufLineCount (hbuf) ;      
            
            i = cmdLnCnt - 1;
            while(i >= 0)
            {
                InsBufLine (hbuf, ln, GetEnv(cat("cmd_str",i)));
                i = i - 1;
            }
            
            SaveBuf (hbuf); 
            CloseBuf (hbuf);

            return cmdLnCnt;
        }
    }
    else
    {
        return cmdLnCnt;
    }
}

//����file�����ݣ���hProj��ӻ�������
macro setCondition(hProj, con_file)
{   
    ln = 0;
    
    if(ifExist(con_file))
    {
        hbuf = OpenBuf(con_file);
        
        ln_cnt = GetBufLineCount(hbuf);
        while(ln<ln_cnt)
        {
            str = GetBufLine(hbuf, ln);

            if(str != " ")
            { 
                DeleteConditionVariable(hProj, nameOf(str));
                AddConditionVariable(hProj, nameOf(str), valueOf(str));
            }   
            ln = ln + 1;
        }

        CloseBuf (hbuf);
    }

    return ln;
}

//��������ڣ�file�ļ�ָ���Ļ�������,����ɾ�����ı�����
macro clearCondition(hProj,file)
{
    if(0 == ifExist(file))
    {
        return 0;
    }
    else
    {
        hbuf = OpenBuf(file);
        ln_cnt = GetBufLineCount (hbuf);
        ln = 0;
        while(ln<ln_cnt)
        {
            str = GetBufLine(hbuf, ln);
            DeleteConditionVariable(hProj ,nameOf(str));
            ln = ln + 1;
        }
        
        CloseBuf (hbuf);
        //SyncProjEx (hProj, 0, 1,0);
        return ln;
    }
}

//�����Լ��������·��
macro searchDir()
{
    hbuf = GetCurrentBuf ();
    dir_str = GetBufName (hbuf);
    pos = strlen(dir_str) - 1;
    while(pos > 0)
    {
        while(pos > 0)
        {
            if(strmid (dir_str, pos, pos + 1) == "\\")
                break;
            pos = pos - 1;
        }
        if(ifExist(cat(strmid(dir_str, 0, pos ),"\\Build\\depend")))
            break;
        pos = pos - 1;
    }
    if(pos > 0)
        return strmid(dir_str, 0, pos );
    else
        return -1;
}
//����make:nothing to been done for all;�����
macro modiFile()
{
    hbuf = GetCurrentBuf ();
    ln_cnt = GetBufLineCount (hbuf);

    if(GetBufLine (hbuf, ln_cnt - 1) == "  ")
        DelBufLine (hbuf, ln_cnt - 1);
    else
        AppendBufLine (hbuf, "  ");

    SaveBuf (hbuf);
}

macro getFileName(str)
{//�������"\"
    pos = strlen(str) - 1;
    while(pos >= 0)
    {   
        if(strmid (str,pos, pos+1) == "\\")
            return pos;
        pos = pos - 1;
    }
}

/*********************End Set Macro Functions*********************/


/*********************Start Other Functions*********************/


/****************************************************************************
 *  Ver:    1.13
 *  Date:   2002.9.18
 *  Author: suqiyuan
 * ================================
 * �����м����������������֧�ֺ���:
 * ʹ����Щ�����ض�Ӧ�ļ��Ϳ�����
 *
 * ���ع�ϵ����:
 * EM_delete:            DELETE
 * EM_backspace:         BACKSPACE
 * EM_CursorUp:          �����Ϸ������
 * EM_CursorDown:        �����·������
 * EM_CursorLeft:        �����������
 * EM_CursorRight:       �����ҷ������
 * EM_SelectWordLeft:    Shift + ��
 * EM_SelectWordRight:   Shift + ��
 * EM_SelectLineUp:      Shift + ��
 * EM_SelectLineUp:      Shift + ��
 ****************************************************************************/
 
 //For keyboard delete
 Macro EM_delete()
 {
    //get current character
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    ln      = GetWndSelLnFirst(hWnd)
    lnLast  = GetWndSelLnLast(hWnd)
    lnCnt   = lnLast - ln + 1
    sel     = GetWndSel(hWnd)
    ich     = GetWndSelIchFirst(hWnd)
    ichLim = GetWndSelIchLim(hWnd)
    hBuf    = GetWndBuf(hWnd)
    curLine = GetBufLine(hBuf,ln)

    //Msg("Now Select lines:@lnCnt@,Line @ln@ index @ich@ to line @lnLast@ index @ichLim@")
    if((lnCnt > 1) || ((lnCnt==1)&&(ichLim>ich)))//ѡ����ǿ�
    {
        //Msg("Selection is One BLOCK.")
        curLine = GetBufLine(hBuf,ln)
        if(ich>0)
        {
            index = 0
            while(index < ich)
            {
                ch = curLine[index]
                if(SearchCharInTab(ch))
                    index = index + 1
                else
                    index = index + 2
            }
            //��������ں����м䣬������ǰ����һ���ֽ�
            sel.ichFirst = ich - (index-ich)
        }
        curLine = GetBufLine(hBuf,lnLast)
        len     = GetBufLineLength(hBuf,lnLast)
        index   = 0
        while(index < ichLim && index < len)
        {
            ch = curLine[index]
            if(SearchCharInTab(ch))
                index = index + 1
            else
                index = index + 2
        }
        sel.ichLim = index
        if(ichLim>len)
            sel.ichLim = ichLim
        SetWndSel(hWnd,sel)
        //Msg("See the block selected is adjusted now.")
        Delete_Character
    }
    else//ѡ��Ĳ��ǿ�
    {
        //Msg("Selection NOT block.")
        curChar = curLine[ich]
        //�������ĩ,Ӧ���ܹ�ʹ����һ��������β
        if(ich == strlen(curLine))
        {
            Delete_Character
            stop
        }
        //Msg("Not at the end of line.")
        flag    = SearchCharInTab(curChar)
        //Msg("Current char:@curChar@,Valid flag:@flag@")
        if(flag)
        {
            //Msg("Byte location to delete:@ich@,Current char:@curChar@")
            DelCharOfLine(hWnd,ln,ich,1)
        }
        else
        {
            /*�����ʵ�ַ�����������:�����׿�ʼ��,�����Table�е�,��һ����
             *�������,�Ӷ�����,һֱ����ǰ�ַ�,������ôɾ��
             *�����������ļٶ�,��ǰ��û�а�����ֵ�����
             */
            index = 0
            word  = 0
            byte  = 0
            len   = strlen(curLine)
            while(index < ich)
            {
                ch   = curLine[index]
                flag = SearchCharInTab(ch)
                if(flag)
                {
                    index = index + 1
                    byte  = byte + 1
                }
                else
                {
                    index = index + 2
                    word  = word + 1
                }
            }
            //index = ich + 1,current cursor is in the middle of word
            //                or in the front of byte
            //index = ich,current cursor is NOT in the front of word
            nich = 2*(word-(index-ich)) + byte
            //Msg("Start deleting position:@ich@,word:@word@,byte:@byte@")
            DelCharOfLine(hWnd,ln,nich,2)
            if((index-ich) && !flag && (ich != len-1))//����һ������ĩβ�ĺ����м�
                Cursor_Left
        }
    }
}

//For keyboard backspace <-
Macro EM_backspace()
{
    //get current character
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    sel     = GetWndSel(hWnd)
    ln      = sel.lnFirst
    ich     = sel.ichFirst
    if(ich < 0)
        stop
    lnLast  = GetWndSelLnLast(hWnd)
    lnCnt   = lnLast - ln + 1
    ichLim = GetWndSelIchLim(hWnd)

    //Msg("Now Select lines:@lnCnt@,Line @ln@ index @ich@ to line @lnLast@ index @ichLim@")
    if((lnCnt > 1) || ((lnCnt==1)&&(ichLim>ich)))//ѡ����ǿ�,ֱ��ɾ��������Ŀ�
    {
        EM_delete
    }
    else
        {if(ich == 0)
        {
            Backspace
            stop
        }
        hBuf    = GetWndBuf(hWnd)
        curLine = GetBufLine(hBuf,ln)

        index = 0
        flag  = 0  // 1-byte,0-word
        byte = 0
        word = 0
        while(index < ich)
        {
            ch   = curLine[index]
            flag = SearchCharInTab(ch)
            if(flag)
                {
                    byte  = byte + 1
                    index = index + 1
                }
            else
                {
                    word  = word + 1
                    index = index + 2
                }
        }
        if(flag)//char before cursor is in table
        {
            //Msg("char before cursor is in table,byte!")
            Backspace
        }
        else if(!flag && (index-ich))//current cursor is in the middle of word
        {
            //Msg("current cursor is in the middle of word.")
            DelCharOfLine(hWnd,ln,ich-1,2)
            if(!(sel.ichFirst == strlen(curLine)-1))
                Cursor_Left
        }
        else if(!flag && !(index-ich))//Current cursor is after a word
        {
            //Msg("Current cursor is after a word.")
            DelCharOfLine(hWnd,ln,ich-2,2)
            if(sel.ichFirst != strlen(curLine))
            {
                Cursor_Left
                Cursor_Left
            }
        }
    }
}

Macro SearchCharInTab(curChar)
{
     /* Total 97 chars */
    AsciiChar = AsciiFromChar(curChar)
    //Msg("Current char in SearchCharInTab():@curChar@.")
    if(AsciiChar >= 32 && AsciiChar <= 126)
        return 1
    //Msg("Current Char(@curChar@) NOT between space and ~")
    if(AsciiChar == 9)//Tab
        return 1
    //Msg("Current Char(@curChar@) NOT Tab")
    if(AsciiChar == 13)//CR
        return 1
    //Msg("Current Char(@curChar@) Not CR")
    return 0
}

Macro DelCharOfLine(hWnd,ln,ich,count)
{
    if(hWnd == 0)
        stop
    sel     = GetWndSel(hWnd)
    hBuf    = GetWndBuf(hWnd)
    if(hBuf == 0)
        stop
    if(ln > GetBufLineCount(hBuf))
        stop
    szLine = GetBufLine(hBuf,ln)
    len    = strlen(szLine)
    if(ich >  len)
        stop

    NewLine = ""
    if(ich > 0)
    {
        NewLine = NewLine # strmid(szLine,0,ich)
    }
    if(ich+count < len)
    {
        ichLim = len
        NewLine = NewLine # strmid(szLine,ich+count,ichLim)
    }
    /**/
    //Msg("Current line:@szLine@")
    //Msg("Replaced as:@NewLine@")
    /**/
    PutBufLine(hBuf,ln,NewLine)
    SetWndSel(hWnd, sel)
}


//���ƹ��
macro EM_CursorUp()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Up

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�
    if (flag == True)
    {
        Cursor_Left
    }
}

//���ƹ��
macro EM_CursorDown()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Down

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�
    if (flag == True)
    {
        Cursor_Right
    }
}


//���ƹ��
macro EM_CursorRight()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Right

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�(�����ʱ��������ƶ�һ���ַ�)
    if (flag == True)
    {
        Cursor_Right
    }
}

//���ƹ��
macro EM_CursorLeft()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop

    hbuf = GetCurrentBuf()

    //�ƶ����
    Cursor_Left

    //����ƶ�����Ĺ��λ��
    hwnd = GetWndhandle(hbuf)
    sel = GetWndSel(hwnd)
    str = GetBufline(hbuf, sel.lnFirst)

    flag = StrChinChk(str, sel.ichFirst)
    //���λ�������ַ�֮������ǰ�ƶ�һ���ַ�(�����ʱ��������ƶ�һ���ַ�)
    if (flag == True)
    {
        Cursor_Left
    }
}

//����ѡ���ַ�
macro EM_SelectWordLeft()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Char_Left

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Left
    }
}

//����ѡ���ַ�
macro EM_SelectWordRight()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Char_Right

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Right
    }
}

//����ѡ���ַ�
macro EM_SelectLineUp()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Line_Up

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Right
    }
}

//����ѡ���ַ�
macro EM_SelectLineDown()
{
    hWnd = GetCurrentWnd()
    if(hWnd == 0)
        stop
    hbuf = GetCurrentBuf()

    //ִ������
    Select_Line_Down

    hwnd = GetWndhandle(hbuf)
    //selold = GetWndSel(hwnd)
    sel = GetWndSel(hwnd)
    //ln = GetBufLnCur(hbuf)

    /*
    if (selold.ichFirst == sel.ichFirst && sel.lnFirst == selold.lnFirst)
        curinhead = 1
    else
        curinhead = 0
    */
    str = GetBufline(hbuf, sel.lnFirst)
    hdflag = StrChinChk(str, sel.ichFirst)

    str = GetBufline(hbuf, sel.lnLast)
    bkflag = StrChinChk(str, sel.ichLim)

    if (hdflag == TRUE || bkflag == TRUE)
    {
        Select_Char_Right
    }
}

//���ַ���str��lnλ���м��
//�����ż���������ַ��򷵻�FALSE
//����������������ַ��򷵻�TRUE
macro StrChinChk(str, ln)
{
    tm  = 0
    flag = False
    len  = strlen(str)
    while (tm < ln)
    {
        if (str[tm] != "")
            ascstr = asciifromchar(str[tm])
        else
            ascstr = 0

        //�����ַ�ASCII > 128
        if (ascstr > 128)
            flag = !flag

        tm = tm + 1
        if (tm >= len)
            break
    }
    return flag
}

// �ڹ����в��Ұ������,����"macro OpenorNewBuf(szfile)"
macro FindHalfChcharInProj()
{
    hprj = GetCurrentProj()
    if (hprj == 0)
        stop
    ifileMax = GetProjFileCount(hprj)
    
    hOutBuf = OpenorNewBuf("HalfChch.txt")
    if (hOutBuf == hNil)
    {
        Msg("Can't Open file:HalfChchar.txt")
        stop
    }
    AppendBufLine(hOutBuf, ">>��������б�>>")
    
    ifile = 0
    while (ifile < ifileMax)
    {
        filename = GetProjFileName(hprj, ifile)
        hbuf = OpenBuf(filename)
        if (hbuf != 0)
        {
            StartMsg("@filename@ is being processing. . . press ESC to cancel.")
            iTotalLn = GetBufLineCount(hbuf)
            iCurLn = 0
            while (iCurLn < iTotalLn)
            {
                str = GetBufline(hbuf, iCurLn)
                flag = StrChinChk(str, strlen(str))
                if (flag == True)
                {
                    // ���ڰ������,��¼�ļ������к�
                    iOutLn = iCurLn + 1
                    outstr = cat(filename, "(@iOutLn@) : ")
                    outstr = cat(outstr, str)
                    AppendBufLine(hOutBuf, outstr)
                    SetSourceLink(hOutBuf,GetBufLineCount(hOutBuf)-1,filename,iCurLn)
                }
                iCurLn = iCurLn + 1
            }
            EndMsg()
        }
        ifile = ifile + 1
    }
    //SetCurrentBuf(hOutBuf)
    //Go_To_First_Link
}

////////////////////////////Functions/////////////////////////////

/* --------------------------------------------------------------
# Module CompleteWord version 0.0.1
# Released to the public domain 14-Aug-1999,
# by Tim Peters (tim_one@email.msn.com).

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!

Word completion.
Macro CompleteWord moves forward.
Macro CompleteWordBack moves backward.
Assign to e.g. F12 and Shift+F12.

The word characters ([a-zA-Z0-9_]) immediately preceding the
cursor are called the "stem".  A "completion" is any full word
that begins with the stem.  Conceptually, all possible
completions are built into a list as follows:

    look backward in the buffer from the stem location,
    and append each completion not seen before

    similarly, look forward in the buffer from the stem
    location for other new completions

    for all other open windows, look forward from the start
    of their buffers for other new completions

CompleteWord then moves forward through this list, and
CompleteWordBack moves backward through it.  If you invoke
CompleteWord when you're already at the end of the list,
a msg pops up telling you so; likewise if you're at the start
of the list and invoke CompleteWordBack.

Each time you move to a new list entry, the stem is completed
and the insertion point is moved to the end of the completion.

Example:

    Py_BEGIN_ALLOW_THREADS
    errno = 0;
    res = fflush(f->f_fp);
    Py_END_ALLOW_THREADS
    if (res != 0) {
        PyErr_SetFromErrno(PyExc_IOError);
        clearerr(f->f_fp);
        return NULL;
    }
    Py_INCREF(Py_None);
    Py_
    Py_SomethingElse();

Suppose the cursor follows the "Py_" on the penultimate line.
Then CompleteWord will first suggest Py_None, then Py_INCREF,
then Py_END_ALLOW_THREADS, then Py_BEGIN_ALLOW_THREADS, then
Py_SomethingElse, and if you're still unhappy <wink> will go on
to search other windows' buffers.

Notes:

 This has nothing to do with Source Insight's notion of "symbols".
  To the contrary, the long hairy words I need to type most often
  over & over are local words that SI's Complete_Symbol doesn't
  know about.  It's also the case that the word you most often
  need to type is one you most recently typed, so the macros
  work hard to suggest the closest preceding matches first.
  This flavor of completion also works fine in file types SI knows
  nothing about.

 The list isn't actually built up at once -- as far as possible,
  it's built incrementally as you continue to invoke CompleteWord.

 It would help if SI's SearchInBuf could search backwards.  As
  is, finding the first suggestion is done by searching the entire
  buffer forward up until the stem location, and fiddling the
  results to act "as if" things were found in the other order.
  This is clumsy, but worse if you're near the end of a long file
  with many stem matches it can take appreciable time to find the
  "first" match (since it's actually found last ...)..

 Would be nice to be able to display msgs on the status line;
  e.g., the macros keep track of the file names and line numbers
  at which completions were found, and that's sometimes useful
  info to know (the completion process sometimes turns up
  surprises! then you'd like to know where they came from).
  The list is built into a buffer named "*Completion*", and you
  may want to peek at that.
-------------------------------------------------------------- */

macro CompleteWord()
{
    CW_guts(1)
}

macro CompleteWordBack()
{
    CW_guts(0)
}

/* BUG ALERT:  there's apparently an undocumented limit on
   string & record vrbl size (about 2**8 chars).  Makes the
   following more convoluted than I'd like, and it will still
   fail in bizarre ways if e.g the stem is "too big".
 */

/* --------------------------------------------------------------
Structure of *Completion* buffer:
    First record summarizes our state:
        .orighbuf   original buffer
        .orighwnd   original window
        .origlno    original line number
        .origi      slice indices of start ...
        .origj      ... and end of stem
        .stem       original stem word
        .newj       where we left insertion point
        .index      index into *Completion* of current completion
        .searchwnd  window we're searching now
        .searchlno  next line number to search at
        .searchich  next char index to search at
    Remaining records detail unique completions:
        .file       name of file match found in
        .line       line number within file of match
        .match      the completion
-------------------------------------------------------------- */

/* Selection format
lnFirst     the first line number
ichFirst    the index of the first character on the line lnFirst
lnLast      the last line number
ichLim      the limit index (one past the last) of the last character
            on the line given in lnLast
fExtended   TRUE if the selection is extended to include more than one
            character
        .   FALSE if the selection is a simple insertion point.
Note: this is the same as the following expression:
(sel.fRect || sel.lnFirst != sel.lnLast || sel.ichFirst != sel.ichLim)

fRect       TRUE if selection is rectangular (block style),
FALSE       if the selection is a linear range of characters.
The following fields only apply if fRect is TRUE:
xLeft       the left pixel position of the rectangle in window coordinates.
xRight      the pixel position of the right edge of the rectangle in
            window coordinates.
*/

/* Completion "word" was found in file "fname" at line "lno".
 * Search hBuf for an exact previous match to "word".  If
 * none found, append a match record to hBuf, and return
 * the match record.  If found and bReplace is false, leave
 * hBuf alone and return "".  Else replace the file & line
 * fields of the matching record, move it to end of the
 * buffer, & return it.
 */
macro CW_addword(word, fname, lno, hBuf, bReplace)
{
    /* SearchInBuf (hbuf, pattern, lnStart, ichStart,
                    fMatchCase, fRegExpr, fWholeWordsOnly)
    */
    foundit = SearchInBuf(hBuf, ";match=\"@word@\"", 1, 0, 1, 0, 0)
    record = ""
    if (foundit == "") {
        record = "file=\"@fname@\";line=\"@lno@\";match=\"@word@\""
    }
    else if (bReplace) {
        record = GetBufLine(hBuf, foundit.lnFirst)
        record.file = fname
        record.line = lno
        DelBufLine(hBuf, foundit.lnFirst)
    }
    if (record != "") {
        AppendBufLine(hBuf, record)
    }
    return record
}

/* Search in hSourceBuf for unique full-word matches to regexp,
 * up through line lastlno, adding match records to hResultBuf.
 * In the end, the match recrods look "as if" we had really
 * searched backward from lastlno, which the closest preceding
 * matches earliest in the list.
 */
macro CW_addallbackwards(regexp, hSourceBuf, hResultBuf, lastlno)
{
    lno = 0
    ich = 0 
    fname = GetBufName(hSourceBuf)
    while (1) {
        /* SearchInBuf(hbuf, pattern, lnStart, ichStart,
                       fMatchCase, fRegExpr, fWholeWordsOnly)
        */
        foundit = SearchInBuf(hSourceBuf, regexp, lno, ich, 1, 1, 1)
        if (foundit == "") {
            break
        }
        lno = foundit.lnFirst
        if (lno > lastlno) {
            break
        }
        ich = foundit.ichLim
        matchline = GetBufLine(hSourceBuf, lno)
        match = strmid(matchline, foundit.ichFirst, ich)
        /* We're forced to search forward, but want the last match
         * (closest preceding the target), so tell CW_addword to
         * replace any previous match.
         */
        CW_addword(match, fname, lno, hResultBuf, 1)
    }
    /* reverse the match order */
    n = GetBufLineCount(hResultBuf) - 1
    i = 1
    while (i < n) {
        r1 = GetBufLine(hResultBuf, i)
        r2 = GetBufLine(hResultBuf, n)
        PutBufLine(hResultBuf, i, r2)
        PutBufLine(hResultBuf, n, r1)
        i = i + 1
        n = n - 1
    }
}

/* The major complication here is that this is essentially an asynch
 * event-driven process:  we don't know what the user has done
 * between invocations, so have to squirrel away and check a lot
 * of state in order to guess whether they're invoking the
 * CompleteWord macros repeatedly.
 */
macro CW_guts(bForward)
{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    if (selection.fExtended) {
        Msg("Cannot word-complete with active selection")
        stop
    }
    hbuf = GetCurrentBuf()
    hResultBuf = GetOrCreateBuf("*Completion*")

    /* Guess whether we're continuing an old one. */
    newone = 0
    if (GetBufLineCount(hResultBuf) == 0) {
        newone = 1
    }
    else {
        stat = GetBufLine(hResultBuf, 0)
        newone = stat.orighbuf != hbuf ||
                 stat.orighwnd != hwnd ||
                 stat.origlno != selection.lnFirst ||
                 stat.newj != selection.ichFirst
    }

    /* suck up stem word */
    if (newone) {
        j = selection.ichFirst  /* index of char to right of cursor */
    }
    else {
        j = stat.origj
    }
    line = GetBufLine(hbuf, selection.lnFirst)
    i = j - 1               /* index of char to left of cursor */
    while (i >= 0) {
        ch = line[i]
        if (isupper(ch) || islower(ch) || IsNumber(ch) || ch == "_") {
            i = i - 1
        }
        else {
            break
        }
    }
    i = i + 1
    if (i >= j) {
        Msg("Cursor must follow [a-zA-Z0-9_]")
        stop
    }
    /* BUG contra docs, line[j] is not included in the following */
    word = strmid(line, i, j)
    regexp = "@word@[a-zA-Z0-9_]+"


    /* BUG "||" apparently doesn't short-circuit, so
            if (newone || word != stat.stem)
       doesn't work (if newone, stat isn't defined)
    */
    if (!newone) {
        /* despite that everything looks the same, they
           may have changed the stem! */
        newone = word != stat.stem
    }
    if (newone) {
        stat = ""
        stat.orighbuf = hbuf
        stat.orighwnd = hwnd
        stat.origlno  = selection.lnFirst
        stat.origi    = i
        stat.origj    = j
        stat.stem     = word
        stat.newj     = j
        stat.index    = 0
        stat.searchwnd = hwnd
        stat.searchlno = selection.lnFirst
        stat.searchich = j
        ClearBuf(hResultBuf)
        AppendBufLine(hResultBuf, stat)
        CW_addallbackwards(regexp, hbuf, hResultBuf, stat.origlno)
        if (GetBufLineCount(hResultBuf) >= 2) {
            /* found at least one completion in this buffer,
               so display the first */
            CW_completeindex(hResultBuf, 1)
            return
        }
    }

    /* continuing an old one, or a new one w/o backward match */
    n = GetBufLineCount(hResultBuf)
    i = stat.index
    if (!bForward) {
        if (i > 1) {
            CW_completeindex(hResultBuf, i - 1)
        }
        else {
            CW_completeword(hResultBuf, word, 0)
            Msg("move forward for completions")
        }
        return
    }

    /* moving forward */
    if (i < n-1) {
        CW_completeindex(hResultBuf, i + 1)
        return
    }

    if (i == n) {
        Msg("move back for completions")
        return
    }

    /* i == n-1: we're at the last one; look for another completion */
    while (1) {
        stat = GetBufLine(hResultBuf, 0)
        hwnd = stat.searchwnd
        lno = stat.searchlno
        ich = stat.searchich
        hbuf = GetWndBuf(hwnd)
        /* SearchInBuf(hbuf, pattern, lnStart, ichStart,
                       fMatchCase, fRegExpr, fWholeWordsOnly)
        */
        if (hBuf == hResultBuf) {
            /* no point searching our own result list! */
            foundit = ""
        }
        else {
            foundit = SearchInBuf(hbuf, regexp, lno, ich, 1, 1, 1)
        }
        if (foundit == "") {
            hwnd = GetNextWnd(hwnd)
            if (hwnd == 0 || hwnd == stat.orighwnd) {
                n = GetBufLineCount(hResultBuf)
                if (n == 1) {
                    Msg("No completions for @word@")
                }
                else {
                    CW_completeword(hResultBuf, word, n)
                    Msg("No more completions for @word@")
                }
                break
            }
            stat.searchwnd = hwnd
            stat.searchlno = 0
            stat.searchich = 0
            PutBufLine(hResultBuf, 0, stat)
            continue
        }
        lno = foundit.lnFirst
        ich = foundit.ichLim
        stat.searchlno = lno
        stat.searchich = ich
        PutBufLine(hResultBuf, 0, stat)
        matchline = GetBufLine(hbuf, lno)
        match = strmid(matchline, foundit.ichFirst, ich)
        result = CW_addword(match, GetBufName(hbuf), lno, hResultBuf, 0)
        if (result != "") {
            CW_completeindex(hResultBuf, GetBufLineCount(hResultBuf) - 1)
            break
        }
    }
}

/* Replace the stem with the completion at index i */
macro CW_completeindex(hBuf, i)
{
    record = GetBufLine(hBuf, i)
    CW_completeword(hBuf, record.match, i)
}

/* Replace the stem with the given completion */
macro CW_completeword(hBuf, completion, i)
{
    stat = GetBufLine(hBuf, 0)
    targetBuf = stat.orighbuf
    oldline = GetBufLine(targetBuf, stat.origlno)
    newline = cat(strmid(oldline, 0, stat.origi), completion)
    newj = strlen(newline)
    newline = cat(newline, strmid(oldline, stat.newj, strlen(oldline)))
    PutBufLine(targetBuf, stat.origlno, newline)
    SetBufIns(targetBuf, stat.origlno, newj)
    stat.newj = newj
    stat.index = i
    PutBufLine(hBuf, 0, stat)
}

////////////////////////////Functions/////////////////////////////

/*
    Macro command that performs a progressive search as the user types.
    
    As with other macros, to use this:
        1. Add this macro file to your project.
        2. Run the Options->Key Assignments command.
        3. Find and select the macro command name in the command list
        4. Press 'Add' to bind a key to the macro.
        Now you can run the macro command
*/


macro ProgressiveSearch()
{
    /* This does a progressive search as the user types characters
       Pressing Enter or Escape will cancel the search 
    */

    hbuf = GetCurrentBuf()
    hwnd = GetCurrentWnd()
    key = 0
    char = 1 // needs to start with any non-zero value
    SearchFor = ""
    sel = GetWndSel(hwnd)
    
    while (char != 0)
    {
        key = GetKey()
        char = CharFromKey(key)
        if (char != 0)
        {
            
            if (key == 13) //Enter searches current string again
                sel.ichFirst = sel.ichFirst + 1
            else if (key == 8) // backspace
            {
                if (strlen(SearchFor) > 0)
                    SearchFor = strtrunc (SearchFor, strlen(SearchFor) - 1)
            }
            else
                SearchFor = cat(SearchFor, char)
            sel = SearchInBuf(hbuf, SearchFor, sel.lnFirst, sel.ichFirst, 0, 0, 0)
            if (sel == "")
            {
                sel = GetWndSel(hwnd)
                if (key == 13)
                {
                    sel.fExtended = 0
                    sel.ichLim = sel.ichFirst
                    SetWndSel(hwnd, sel)
                    char = 0
                    Beep()
                }
                else  
                    if (strlen(SearchFor) > 0)
                        SearchFor = strtrunc (SearchFor, strlen(SearchFor) - 1)
            }
            else
            {
                ScrollWndToLine(hwnd, sel.lnFirst)
                SetWndSel(hwnd, sel)
                LoadSearchPattern(SearchFor, 0, 0, 0)
            }
        }
    }
}
    

