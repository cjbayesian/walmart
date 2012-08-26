
zips<-read.csv('zipcodes/zipcode.csv')
zips<-zips[zips$state!="AK",] #Alaska
zips<-zips[zips$state!="HI",] #Hawaii
zips<-zips[zips$state!="PR",] #Puerto Rico 
zips<-zips[zips$state!="AS",] #American Samoa
zips<-zips[zips$state!="VI",] #Virgin Islands

plot(zips$longitude,zips$latitude)

d<-read.csv('store_openings.csv')
d$OPENDATE<-as.character(d$OPENDATE)
opendate<-t(simplify2array(strsplit(d$OPENDATE,"/")))
opendate<-array(as.integer(opendate),dim=c(nrow(opendate),3))


new_stores<-numeric(diff(range(opendate[,3]))*12)
month_count<-2

stores<-as.list(rep(1,diff(range(opendate[,3]))*12+1))
stores[[1]]<-NA

for(year in min(opendate[,3]):max(opendate[,3]) )
{
	for(month in 1:12)
	{
		print(c(year,month))
		new_stores[month_count-1]<-(sum(opendate[,1]==month & opendate[,3]==year))
		stores[[month_count+1]]<-c(stores[[month_count]],which(opendate[,1]==month & opendate[,3]==year))
		month_count<-month_count+1
	}
}
plot(cumsum(new_stores))

index_zip<-numeric(length(stores[[542]]))
for( i in stores[[542]] )
{
   if(d$ZIPCODE[i] %in% zips$zip)
    index_zip[i]<-which(zips$zip==d$ZIPCODE[i])
   else
    index_zip[i]<-NA
}

#library(maps)
#map("state", boundary = FALSE, col="gray", add = TRUE)

library(fields) #for US() map

tot_stores<-1
i<-1
for(year in min(opendate[,3]):max(opendate[,3]) )
{
   print(year)
	for(month in 1:12)
	{
      png(paste(year,'_',100+month,'.png',sep=''),width=750,height=500)
      US(main='The Walmart Invasion')
      points(zips$longitude[index_zip[1:(tot_stores+new_stores[i])] ],
            zips$latitude[index_zip[1:(tot_stores+new_stores[i])]],
            pch=20)
      points(zips$longitude[index_zip[tot_stores:(tot_stores+new_stores[i])] ],
            zips$latitude[index_zip[tot_stores:(tot_stores+new_stores[i])] ],
            col='red',
            pch=20)
      subplot(plot(cumsum(new_stores[1:i],lwd=1.5),
               type='l',
               ylab='',
               xlab='',
               xaxt='n'), 
            size=c(1.5,1.5),
            -124.2, 
            24.3,
            vadj=0,hadj=0)
      text(-122,32.75,'# of Stores')

      mtext(year,line=1,side=1,cex=2)

      tot_stores<-tot_stores+new_stores[i]
      i<-i+1
      dev.off()
   }
}

#system('convert -delay 10 *.png ani.gif')
system('mencoder mf://*.png -mf fps=15:type=png -ovc copy -oac copy -o output.avi')



