
CZdata <-function(fun = median) {
  
  f = as.character(substitute(fun))
  d = dbGetQuery(options()$cz.con, paste(
      '
      SELECT R, G, B, w.ID, w.mark, f.path
      FROM
       (SELECT', f,'(R) R,', f,'(G) G,', f,'(B) B, roi_pk FROM RGB group by roi_pk) c
      JOIN ROI w
      ON c.roi_PK = w.pk
      JOIN files f
      ON f.id = w.id
      order by f.id
      
      
      ') )
  d    
      
  
}

