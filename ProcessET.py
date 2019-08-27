from pandas import read_csv,pivot_table,Series,to_numeric,concat
import sys
import json
import math
import os
import csv
import numpy as np
save_path = './'
class gen():
    def __init__(self,uploads):
        self.do(uploads)
    def do(self,uploads):
        self.Das=datas()
        for upload in uploads:
            upload.save(save_path,overwrite=True)
            Da=data(upload.filename)            
            self.Das.addda(Da)
        self.Das.makemean()        
        
    def dcm_gen(self,qlist):
        myDCM=DCM(self.Das.meanda.df,qlist)
        return myDCM.dcm


    def json_gen(self,qlist):
        '''prepare dict for return value json'''
        ret={} 
        ret['status']='OK'
        ret['files']=self.Das.len
        ret['plots']={}
        for i in range(self.Das.len):
            ret['plots'][self.Das.das[i].name]=json.loads(self.Das.das[i].df.to_json())
        if(self.Das.len>1):
            ret['plots']['mean']=json.loads(self.Das.meanda.df.to_json())
            ret['DCM']=self.dcm_gen(qlist).to_html(float_format=lambda x: "{0:2f}".format(x))
        return json.dumps(ret)
        #return str(ret)
    # except:
        #   return "nok"
class DCM():
    def __init__(self,mean,qlist=None):
        self.mean=mean
        self.qlist=np.trim_zeros(qlist, 'b') or [0,0.5,0.75,1.,2.,3.,4.,6.,8.,10.,20.,40.,60.,80.,100.,120.]
        self.process()
    def process(self):
        df=self.mean
        qlist=self.qlist
        df=df.rolling(window=5,center=False).mean()
        df.loc[10000]=df.apply(self.ext)
        t=[]
        t.append(df.apply(self.convert))
        df1=concat(t,axis=1)
        ext=Series(2*df1.loc[:,250000]-df1.loc[:,300000],index=qlist,name='100000')

        df1=concat([ext,df1],axis=1)
        df1.loc[df1.index==0]=0
        for row in range(len(df1.index)):
            for col in range(len(df1.columns)-1)[::-1]:
                if df1.iloc[row,col]<df1.iloc[row,col+1]:
                    df1.iloc[row,col]=df1.iloc[row,col+1]
        self.dcm=df1
    def ext(self,col):
        c=len(col)
        last=col.iat[-1]
        lastkey=col.index[-1]
        mid=math.ceil(c*0.8)
        start=col.iat[mid]
        startkey=col.index[mid]
        g=(last-start)/(lastkey-startkey)
        return last+g*(10000-lastkey)
    def convert(self,col):
        col=col.sort_index(ascending=False)
        res=[]
        
        #print(col.name)
        for q in self.qlist:
            temp=None #store k temperary
            ET=None
            for k,v in col.iteritems():
                #k=float(k)
                if q==v:
                    ET=k
                    break            
                elif q<v:
                    temp=v
                    key=k
                    continue
                elif temp!=None:
                    g=(temp-v)/(key-k)                    
                    intq=(g*(key)-temp+q)/g
                    ET=intq
                    break
            res.append(4000 if ET==None else ET)
        return Series(res,index=self.qlist,name=col.name)
class datas():
    def __init__(self):
        self.das=[]
        self.len=0
        self.meanda=None
    def addda(self,da):
        self.das.append(da)
        self.len += 1
    def makemean(self):        
        if(self.len>1):
            meandf=self.das[0].df.copy(deep=True)
            for i in range(1,self.len):
                meandf=meandf.add(self.das[i].df,fill_value=0)
            #meandf.apply(lambda x: x / self.len)
            self.meanda=data("mean",meandf / len(self.das))
#此函数接受一个参数并返回轨压列表
def genrailp(count):    
    #如果一共设定了n次轨压，最高轨压即为n*100bar，其他轨压顺延，最后一个轨压是250bar
    r=[i*100000 for i in range(count+1,2,-1)]
    r+=[250000]
    return r
def railpgen(se,cnt):
    railp_=genrailp(cnt)
    match=0
    for k,v in se.iteritems():
        if(v==1):            
            se[k]=railp_[match]
            match+=1
class data():
    def __init__(self,filename,df=None):
        self.name=filename
        if(df is None):
            self.df=self.fileTodf(self.name)
            os.remove(filename)
        else:
            self.df=df

    def fileTodf(self,filename):

        sep=self.getsep(filename)
        m=read_csv(filename,sep=sep,header=None,encoding='latin_1',skiprows=3,skipinitialspace=True)        
        m.columns=m.loc[0,:]
        dd=m.iloc[2:,:]
        Qlist=["V_Inj1(HDA_1)","Q_1(Emi)","Q_1(Emi2)"]
        head=m.loc[0,:]
        Qlabel=head[head.isin(Qlist)][0]
        if("p_Rail(ASAP)" in m.columns): #if rail pressure setpoint exists
            xd=dd.loc[:,["SendAsapCmd(ASAP)_1","p_Rail(ASAP)",Qlabel]]
            xd['p_Rail(ASAP)'].fillna(method='ffill',inplace=True)
        else: #rail pressure missing
            railp_col=dd.Lastpunkt#.copy()
            cnt=dd.Lastpunkt[dd.Lastpunkt=="Set_pRail"].count()
            railp_col=(railp_col=="Set_pRail").astype(int)
            railp_col.replace(0,np.nan,inplace=True)
            railpgen(railp_col,cnt)
            xd=dd.loc[:,["SendAsapCmd(ASAP)_1",Qlabel]]
            xd['p_Rail(ASAP)']=railp_col.fillna(method='ffill')
         
        xd.dropna(subset=[Qlabel],inplace=True) 
        xd=xd.apply(to_numeric) 
        ff=pivot_table(xd,index='SendAsapCmd(ASAP)_1',columns='p_Rail(ASAP)') 
        ff.columns=ff.columns.droplevel()
        return ff
    def getsep(self,filename):        
        with open(filename, newline='',encoding='latin_1') as csvfile:
            dialect = csv.Sniffer().sniff(csvfile.readline())
        return dialect.delimiter
