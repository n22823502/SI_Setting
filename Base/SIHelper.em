/*********************************************
SIHelper.em: Source Insight���ֺ�
**********************************************/

/* ����ǩ���� */
macro SIH_CodeFavor()
{
    if(0 == GetCurrentProj())
    {
        msg("Source Insightδ�򿪹���!");
        return;
    }
    
    curFile = "";
    hwnd = GetCurrentWnd();
    if(hwnd != 0)
    {
        hbuf = GetWndBuf(hwnd)
        /* �õ���ǰ�ļ� */    
        curFile = GetBufName(hbuf);

        /* �õ���ǰ���� */
        curSymbol = GetcurSymbol();        
    }

	/*������ò���*/
    Para = "-st \""; /*����-s:��Source Insight�е���,-t:�ö�*/
    Para = cat(Para,curFile);    
    Para = cat(Para,"|");
    Para = cat(Para,GetProjDir(GetCurrentProj()));    
    Para = cat(Para,"|");    
    Para = cat(Para,curSymbol);    
    Para = cat(Para,"\"");

    /* ����CodeFav���� */
    SIHPath = getreg(SIH_ProPath);
    SIHPath = cat(SIHPath, "CodeFav.exe");
    retRun  = ShellExecute("open", SIHPath, Para, "", 1);
    if(0 == retRun)
    {
        msg(cat("�������ʧ��: ",SIHPath));    
    }
}


/* �����ǩ */
macro SIH_AddCodeFavor()
{
    if(0 == GetCurrentProj())
    {
        msg("Source Insightδ�򿪹���!");    
        return;
    }
    
    curFile = "";
    hwnd = GetCurrentWnd();
    if(hwnd != 0)
    {
        hbuf = GetWndBuf(hwnd)
        /* �õ���ǰ�ļ� */
        curFile = GetBufName(hbuf);

        /* �õ���ǰ���� */
        curSymbol = GetcurSymbol();        
    }

	/*������ò���*/
    Para = "-as \""; /*����-a:��ӷ���ģʽ;
                                      ����-s:�����Ǵ�Source Insight�е��õ�*/
    Para = cat(Para,curFile);    
    Para = cat(Para,"|");
    Para = cat(Para,GetProjDir(GetCurrentProj()));    
    Para = cat(Para,"|");    
    Para = cat(Para,curSymbol);    
    Para = cat(Para,"\"");

    /* ����CodeFav���� */
    SIHPath = getreg(SIH_ProPath);
    SIHPath = cat(SIHPath, "CodeFav.exe");
    retRun  = ShellExecute("open", SIHPath, Para, "", 1);
    if(retRun == 0)
    {
        msg(cat("�������ʧ��: ",SIHPath));    
    }
}

/* 
������ش���
�ú��ɲ�����򷵻�ʱ�Զ�����
����Ϊ�ú�����ݼ�Ctrl+Alt+R
*/
macro SIH_OnEvent_Ctrl_Alt_R()
{
    retType = getreg(SIH_Ret_Type);
    retFile = getreg(SIH_Ret_File);
    retSymbol = getreg(SIH_Ret_Symbol);

    setreg(SIH_RETURN, "1"); //��ʶ�յ�������Ϣ

    if(retType == "jump") //��ת������
    {
        JumpToSymbolDef(retSymbol);
    }
    else if(retType == "file") //���ļ�
    {
        if(FALSE == openMiscFile(retFile))        
        {
            errormsg = "���ļ�ʧ��:";
            errormsg = cat(errormsg, retFile);
            msg(errormsg);
        }
    }
    else if(retType == "insert") //�������
    {
        hwnd = GetCurrentWnd();
        if(hwnd != 0)
        {
            hbuf = GetWndBuf(hwnd)
            memGet = getreg(MEM_GET);
            if(memGet != "")
                SetBufSelText(hwnd, memGet);
        }    
    }
}

/* �����������(SearchResult)�е������ļ� */
macro SIH_SearchExport()
{
    if(0 == GetCurrentProj())
    {
        msg("Source Insightδ�򿪹���!");    
        return;
    }

    curFile = "";
    hwnd = GetCurrentWnd();
    if(hwnd != 0)
    {
        hbuf = GetWndBuf(hwnd)
        /* �õ���ǰ�ļ� */
        curFile = GetBufName(hbuf);
        /* �õ���ǰ���� */
        curSymbol = GetcurSymbol();        
    }

	/*������ò���*/
    Para = "\"";
    Para = cat(Para,curFile);    
    Para = cat(Para,"|");
    Para = cat(Para,GetProjDir(GetCurrentProj()));    
    Para = cat(Para,"\"");

    /* ����SearchExport���� */
    SIHPath = getreg(SIH_ProPath);
    SIHPath = cat(SIHPath, "SearchExport.exe");
    retRun  = ShellExecute("open", SIHPath, Para, "", 1);
    if(0 == retRun)
    {
        msg(cat("�������ʧ��: ",SIHPath));    
    }
}

