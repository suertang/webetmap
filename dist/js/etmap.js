function sh(){
    qform=[]
    li=$('input:checked').parent('td').siblings('td')
    li.map(function(x){qform.push(li[x].innerText)})
    return(qform)
}

        $(document).ready(function(){
        var qlist={'PC':[0,0.5,0.75,1.,2.,3.,4.,6.,8.,10.,20.,40.,60.,80.,100.,120.,0,0,0,0,0,0],
                    'CV':[0,1.5,3,6,10,15,20,30,40,50,60,70,80,90,110,130,150,170,190,210,230,250]}
        //d=$('table').append($("tr").append(function(){for(var q in qlist){"<td>"+qlist[q]+"</td>"}))
        table=$("<table><thead><caption onclick='sh()'>DCM quantity list</caption></thead></table>")
        for(var seg in qlist){
            var row=$('<tr></tr>')
            for(var q in qlist[seg]){
                row.append($("<td></td>").text(qlist[seg][q]).width(35).addClass('edit'))
            }
            row.prepend($("<td></td>").width(60).html($("<input type='radio' name='seg'>").attr('value',seg).attr('checked',seg=="PC")).append(seg))
            table.append(row)
        }
        





        $('#qlist').append(table).attr('class','qtable')
        
                $('#drop_zone_home').hover(function(){
                    $(this).children('p').stop().animate({top:'0px'},200);
                },function(){
                    $(this).children('p').stop().animate({top:'-44px'},200);
                });
                
                
                
                $(document).on({
                    dragleave:function(e){        //拖离
                        e.preventDefault();
                        $('.dashboard_target_box').removeClass('over');
                    },
                    drop:function(e){            //拖后放
                        e.preventDefault();
                    },
                    dragenter:function(e){        //拖进
                        e.preventDefault();
                        $('.dashboard_target_box').addClass('over');
                    },
                    dragover:function(e){        //拖来拖去
                        e.preventDefault();
                        $('.dashboard_target_box').addClass('over');
                    }
                });
                
                //================上传的实现
                var box = document.getElementById('target_box'); //获得到框体
                
                box.addEventListener("drop",function(e){
                    
                    e.preventDefault(); //取消默认浏览器拖拽效果
                    
                    var fileList = e.dataTransfer.files; //获取文件对象
                    //fileList.length 用来获取文件的长度（其实是获得文件数量）
                    
                    //检测是否是拖拽文件到页面的操作
                    if(fileList.length == 0){
                        $('.dashboard_target_box').removeClass('over');
                        return;
                    }
                    //检测文件是不是图片
                    $('#pic').text("Loading... please wait...")
                    xhr = new XMLHttpRequest();
                    xhr.onload=function(){
                        $("#pic").html("")
                        loadjson(xhr.responseText)
                    }
                    xhr.open("post", "/", true);
                    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
                    
                    var fd = new FormData();
					for(var i in fileList)
                        fd.append('data[]',fileList[i]);
                    fd.append('qlist',sh())
                    xhr.send(fd);
                    s=0
                     
                },false);
        $('label').click(function(){
            //alert(!$("input[type='radio']:checked").val())
            if(!$("input[type='radio']:checked").val()){
                alert("Please select DCM quantity list!")
                return false;
            }
        })
        $('#uploadbox').change(function(e){


                    var fileList = $(this)[0].files; //获取文件对象

                    if(fileList.length == 0){
                        alert('No file detected')
                        //$('.dashboard_target_box').removeClass('over');
                        return;
                    }
                    
                    $('#pic').text("Loading... please wait...")
                    xhr = new XMLHttpRequest();
                    xhr.onload=function(){
                        $("#pic").html("")
                        loadjson(xhr.responseText)
                    }
                    xhr.open("post", "/", true);
                    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
                    
                    var fd = new FormData();
					for(var i in fileList)
                        fd.append('data[]',fileList[i]);
                    fd.append('qlist',sh())
                    xhr.send(fd);
                    s=0
                    
                })
        ////////////////
        //make editable
        $('td.edit').dblclick(function(){
            if($(this).hasClass('editing')){
                return;
            }
            w=$(this).width()
            h=$(this).height()
            newele=$('<input type="text">').width(w).height(h).attr('value',$(this).text()).blur(function(){
                //return;
                val=$(this).val()
                $(this).parent("td").text(val).removeClass('editing')
            }).addClass('inlineedit')
            
            //$(this).text("")
            $(this).html(newele).addClass('editing')
            $(this).find('input').focus()
            
        })


        /////////////////////////////////////////////
        //text area editable
        //editarea
        $('div.editarea').dblclick(function(){
            alert('aa')
            if($(this).hasClass('editing')){
                return;
            }
            w=$(this).width()
            h=$(this).height()
            newele=$('<textarea></textarea>').width(w).height(h).attr('value',$(this).text()).blur(function(){
                //return;
                val=$(this).val()
                $(this).parent("div").text(val).removeClass('editing')
            }).addClass('inlineedit')
            
            //$(this).text("")
            $(this).html(newele).addClass('editing')
            $(this).find('textarea').focus()
            
        })
        //end textarea editable

        });
        var options={
            legend: {
                labelBoxBorderColor: "#000000",  
                noColumns: 1
            },
            yaxis : {
            show : true,
            axisLabel : 'Injected quantity [mm^3/str]',
            position: 'left',
            },
            xaxis : {
                show : true,
                axisLabel : 'ET [us]',
            }
        }
        function loadjson(json_str){
            var jsp=$.parseJSON(json_str)
            js=jsp['plots']
            cntChart=0
            for(var ch in js){
                plotarea=$("<div width='800'></div>")
                if(cntChart==0){
                    plotarea.append("<h3>1. Q map for individual injector</h3>")
                    //firstChart=false
                }
                if(ch=='mean'){
                    plotarea.append("<h3>2. Mean Q map</h3>")
                }
                //plotarea.append("<div class='chart_title'>"+ch+"</div>")
                
                plotarea.append("<div class='xplot'></div>")
                //
                dataframe=[]
                
                //js=js.concat()
                for(var item in js[ch]){
                    series={}
                    series.label = item;
                    series.data = [];
                    for(var i in js[ch][item]){
                        series.data.push([i,js[ch][item][i]])
                    }
                    dataframe.push(series)
                }
                $('#pic').append(plotarea)
                plotarea.append($("<div class='xleg'></div>").attr('ID','xleg'+cntChart))
                xoptions=options;
                xoptions.legend.container=$('#xleg'+cntChart)
                $.plot(plotarea.find('.xplot') , dataframe,xoptions);
                if(cntChart==0){
                    plotarea.append($('#sign').show())
                }
                cntChart++
            }
            plot_all();
            dcm_plot();
            plot_summary();
            function plot_all(){
                alldata=$.parseJSON(json_str)['plots'] //raw data
                plotarea=$("<div width='800'></div>")
                
                plotarea.append("<h3>3. Q map for all injectors</h3>")
                //plotarea.append("<h2 class='chart_title'>All</h2>") 
                plotarea.append("<div class='xplot'></div>")
                dataframe=[]
                colorlist=['red','green','blue','black']
                colorindex=0
                for(var p in alldata){ //each file
                    d=alldata[p]                
                    idx=colorindex++
                    for(var i in d){                    
                        series={}
                        series.data = [];
                        series.color=colorlist[idx]
                        for(var j in d[i]){
                            series.data.push([j,d[i][j]])
                        }
                        dataframe.push(series)
                    }                    
                }
                $('#pic').append(plotarea)
                plotarea.append($("<div class='xleg'></div>").attr('ID','xleg'+cntChart))
                xoptions=options;
                xoptions.legend.container=$('#xleg'+cntChart)
                $.plot(plotarea.find('.xplot') , dataframe,xoptions);
                $.plot(plotarea.find('.xplot') , dataframe,xoptions);
            }

            function dcm_plot(){
                dcm=$.parseJSON(json_str)['DCM']
                plotarea=$("<div width='800'></div>").css('overflow','auto')
                
                plotarea.append("<h3>4. ET MAP <button onclick='exportTableToCSV()' class='btnDown'>Download DCM</button></h3>") 
                plotarea.append(dcm)
                $('#pic').append(plotarea)
                $('.dataframe td,th').text(function (){

                    txt=$(this).text()
                    if(txt*1>10000){
                        return txt*1/1000
                    }else if(txt==""){
                        return ""
                    }else{
                        return Math.round($(this).text()*100)/100
                    }
                    
                })
            }
            function plot_summary(){
                summary="To ensure the accuracy, the mean value injector with SN:0037 is measured three times. In the Q-MAP of all measurings, it shows normal behavior and good repeatibility concerning injection quantity.The ET-MAP created is based on the average value of mean value injector measured."
                plotarea=$("<div width='800'></div>").addClass('summary')
                plotarea.append("<h3>5. Summary</h3>")
                plotarea.append($("<div></div>").html("<div class='editarea'>"+summary+"</div>"+"<br><br>RBCD/ESD1<br><br> <span class='edit'>Rong Yiyi</span>"))
                
                $('#pic').append(plotarea)
                $('.editarea').dblclick(function(){
                    //alert('aa')
                    if($(this).hasClass('editing')){
                        return;
                    }
                    w=$(this).width()
                    h=$(this).height()
                    newele=$('<textarea></textarea>').width(w).height(h).text($(this).text()).blur(function(){
                        //return;
                        val=$(this).val()
                        $(this).parent("div").text(val).removeClass('editing')
                    }).addClass('inlineedit')
                    
                    //$(this).text("")
                    $(this).html(newele).addClass('editing')
                    $(this).find('textarea').focus()                    
                })
                $('span.edit').dblclick(function(){
                    //alert('aa')
                    if($(this).hasClass('editing')){
                        return;
                    }
                    w=$(this).width()
                    h=$(this).height()
                    newele=$('<input type="text">').addClass('editing').width(w).height(h).attr('value',$(this).text()).blur(function(){
                        //return;
                        val=$(this).val()
                        $(this).parent('span').text(val).removeClass('editing')
                    }).addClass('inlineedit')
                    
                    //$(this).text("")
                    $(this).html(newele).addClass('editing')
                    newele.focus()
                })
                plotarea=$("<div width='800'></div>").addClass('recp')
                plotarea.append("<h3>6. Attachment-Test Sepcification</h3>")
                plotarea.append($("<div></div>").text("drag pic").height(300).width(800).css('border','1px dotted').attr('ID','droppic').on("dragleave",false).on('dragover', false).on('drop',function(e){
                    e.preventDefault()
                    e.stopPropagation();
                    var files = e.originalEvent.dataTransfer.files; //获取文件对象
                    if(files.length == 0){
                        return;
                    }
                    holder=$(this)
                    handleFiles(files);
                    function handleFiles(files) {

                        for (var i = 0; i < files.length; i++) {

                        // get the next file that the user selected
                        var file = files[i];
                        var imageType = /image.*/;

                        // don't try to process non-images
                        if (!file.type.match(imageType)) {
                            continue;
                        }

                        // a seed img element for the FileReader
                        var img = document.createElement("img");
                        img.classList.add("obj");
                        img.file = file;

                        // get an image file from the user
                        // this uses drag/drop, but you could substitute file-browsing
                        var reader = new FileReader();
                        reader.onload = (function(aImg) {
                            return function(e) {
                            aImg.onload = function() {

                                // draw the aImg onto the canvas
                                var canvas = document.createElement("canvas");
                                var ctx = canvas.getContext("2d");
                                canvas.width = aImg.width;
                                canvas.height = aImg.height;
                                ctx.drawImage(aImg, 0, 0);

                                // make the jpeg image
                                var newImg = new Image();
                                newImg.onload = function() {
                                    newImg.id = "newest";
                                    holder.html($(newImg).width(800));
                                }
                                newImg.src = canvas.toDataURL('image/jpeg');
                                }
                                // e.target.result is a dataURL for the image
                            aImg.src = e.target.result;
                            };
                        })(img);
                        reader.readAsDataURL(file);

                        } // end for

                    } // end handleFiles

                })
                ) //end append
                $('#pic').append(plotarea)
            }

            $('#info').show() //report header show after the process is finished.
        }

        
