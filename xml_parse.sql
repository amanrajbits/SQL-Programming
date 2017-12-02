SELECT pr.ciid,
	'"'+ 
		isnull(Replace(Replace(Replace((SELECT TOP 1 x.value('Response[1]','varchar(max)') FROM   pr.processed_xml.nodes('/Result') p(x)) , Char(13) , ''), Char(10), ''), Char(9),''),
		Replace(Replace(Replace((SELECT TOP 1 x.value('Response[1]','varchar(max)') FROM   pr.processed_xml.nodes('/Result/Question') p(x)) , Char(13) , ''), Char(10), ''), Char(9),'')
			  )+ '"' as Response
	from ProResponse pr (nolock) 
