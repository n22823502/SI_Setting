/* Ϊ�½��� .c,.h �ļ�Ӧ��ģ��*/
event DocumentNew(sFile)
{
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
	stop
	hbuf = GetWndBuf(hwnd)

	ln = 0;
	extType = GetFileNameExt(sFile);

	if(extType == "c")
	{
		InsertFileHeaderCN(hbuf,ln);
	}
	else if(extType == "h")
	{
		InsertCPP(hbuf,ln)
		InsertFileHeaderCN(hbuf,ln);
	}
}
