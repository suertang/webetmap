<!DOCTYPE HTML>
        <html>
        <head>
        <meta charset="utf-8">
        <title>ET_MAP</title>
        <script src="js/jquery-3.2.1.min.js"></script>
        <script src="js/jquery.flot.js"></script>
        <script src="js/jquery.flot.axislabels.js"></script>
        <script src="js/expDCM.js"></script>
        <link rel="stylesheet" type="text/css" href="css/etmap.css?a">
        <script>
        function sh(){
            qform=[]
            li=$('input:checked').parent('td').siblings('td').find('input')
            li.map(function(x){qform.push(li[x].value)})
            return(qform)
        }



        
        var modal = (function(){
				var 
				method = {},
				$overlay,
				$modal,
				$content,
                $close,
                $btn;

				// Center the modal in the viewport
				method.center = function () {
					var top, left;

					top = Math.max($(window).height() - $modal.outerHeight(), 0) / 2;
					left = Math.max($(window).width() - $modal.outerWidth(), 0) / 2;

					$modal.css({
						top:top + $(window).scrollTop(), 
						left:left + $(window).scrollLeft()
					});
				};

				// Open the modal
				method.open = function (settings) {
					$content.empty().append(settings.content);

					$modal.css({
						width: settings.width || 'auto', 
						height: settings.height || 'auto'
					});

					method.center();
					$(window).bind('resize.modal', method.center);
					$modal.show();
					$overlay.show();
				};

				// Close the modal
				method.close = function () {
					$modal.hide();
					$overlay.hide();
					$content.empty();
					$(window).unbind('resize.modal');
				};
                method.data = null;
                method.save = function(){
                    method.data = sh();
                    $modal.hide();
					$overlay.hide();
                    $content.empty();                    
                    //console.log(method.data)
                    $(window).unbind('resize.modal');
                    $('#uploadbox').click()
                    //$('#uploadbox').change()
                }
				// Generate the HTML and add it to the document
				$overlay = $('<div id="overlay"></div>');
				$modal = $('<div id="modal"></div>');
				$content = $('<div id="content"></div>');
				$close = $('<a id="close" href="#">close</a>');
                $btn = $('<input type="button" value="Confirm" id="confirm">');
				$modal.hide();
				$overlay.hide();
				$modal.append($content, $close, $btn);

				$(document).ready(function(){
					$('body').append($overlay, $modal);						
				});
                $btn.click(function(e){
                    e.preventDefault();
                    method.save()
                });
				$close.click(function(e){
					e.preventDefault();
					method.close();
				});

				return method;
			}());

            function savecfg(){
                var filename = "etmap.cfg"
                var cfg=[]
                var inputs=document.querySelectorAll("input");
                for(var i=0;i<inputs.length;i++){
                    cfg.push(inputs[i].value)
                }
                downloadCSV(cfg.join('\r\n'),filename)
            }

            function loadcfg(cfg){
                var file = cfg;
                var reader  = new FileReader();

                reader.onloadend = function () {
                    var cfglist=reader.result.split('\r\n')
                    var inputs=document.querySelectorAll("input");
                    for(var i=0;i<inputs.length;i++){
                        inputs[i].value=cfglist[i]
                    }
                }
                if (file) {
                    reader.readAsDataURL(file);
                }
            }

        function showModal(){
            var qlist={ 'PC':[0,0.5,0.75,1.,2.,3.,4.,6.,8.,10.,20.,40.,60.,80.,100.,120.,0,0,0,0,0,0],
                        'CV':[0,1.5,3,6,10,15,20,30,40,50,60,70,80,90,110,130,150,170,190,210,230,250]}
            //d=$('table').append($("tr").append(function(){for(var q in qlist){"<td>"+qlist[q]+"</td>"}))
            table=$("<table class='modal'><thead><caption class='caution'>Please confirm the DCM template</caption></thead></table>")
        
            
            r=$('<tr></tr>')
            for(var i=0;i<22;i++){
                r.append($("<td></td>").text(i+1).width(30))
            }
            r.prepend($("<td></td>").width(60).html('id'))
            table.append(r)
            for(var seg in qlist){
                var row=$('<tr></tr>')
                for(var q in qlist[seg]){
                    row.append($("<td></td>").append($("<input type='text' class='form1'>").val(qlist[seg][q]).width(30).addClass('edit')))
                }
                row.prepend($("<td></td>").width(60).html($("<input type='radio' name='seg'>").attr('value',seg).attr('checked',seg=="PC")).append(seg))
                table.append(row)
            }
            //$('body').append(table).attr('class','qtable').show()
            return table;
        }
        $(document).ready(function(){
           $('#savebox').click(function(){
                var filename = "etmapconfig.txt"
                var cfg=[]
                var inputs=document.querySelectorAll("input");
                for(var i=0;i<inputs.length;i++){
                    cfg.push(inputs[i].value)
                }
                downloadCSV(cfg.join('\r\n'),filename)
           })
           $('#loadbox').change(function(){
                var file = this.files[0];
                var reader  = new FileReader();

                reader.onloadend = function () {
                    var cfglist=reader.result.split('\r\n')
                    var inputs=document.querySelectorAll("input");
                    for(var i=0;i<inputs.length;i++){
                        try{
                            inputs[i].value=cfglist[i]
                        }
                        catch(e){
                            console.log(e.message)
                        }
                        
                    }
                    $(this).val('')
                }
                if (file) {
                    reader.readAsText(file);
                }
           })



        
        /*
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
        */
        $('#start').click(function(e){
            e.preventDefault();
            modal.open({content: showModal()});
            $('#intro').hide()
        })
        $('#uploadbox').change(function(e){
                    //console.log($(this).val())
                    //console.log("ddd",modal.data)
                    //return false;
                    e.stopPropagation()
                    if($(this).val()==''){
                        return
                    }
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
                    fd.append('qlist',modal.data)
                    xhr.send(fd);
                    modal.data = null;
                    $(this).val('')
                    //$(this).val('empty')
                    //s=0
                    
                })
        ////////////////
        //make editable
        /***********************************
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
        ***********/
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
            },
            lines:{
                
                //lineWidth: 1
            },
            shadowSize:0,
            colors:['#E20015', '#B90276', '#50237F', '#005691', '#BFC0C2', '#008ECF', '#00A8B0', '#78BE20', '#006249','#525F6B','#EA6876','#D067AD','#967CB1','#6d9abc','#6FB9E2','#D7D7DA']
        }
        var optionsmall={
            legend: {
                show:false
            },
            yaxis : {
                show : true,
                position: 'left',
                min: 0,
                max: 20
            },
            xaxis : {
                show : true,
                min: 80,
                max: 500
            },
            shadowSize:0,
            colors:['#E20015', '#B90276', '#50237F', '#005691', '#BFC0C2', '#008ECF', '#00A8B0', '#78BE20', '#006249','#525F6B','#EA6876','#D067AD','#967CB1','#6d9abc','#6FB9E2','#D7D7DA']
        }
        function loadjson(json_str){
            var jsp=$.parseJSON(json_str)
            var js=jsp['plots']
            var cntChart=0
            for(var ch in js){
                plotarea=$("<div width='800'></div>")
                if(cntChart==0){
                    plotarea.append("<h3>1. Q map for individual injector</h3>")
                    //firstChart=false
                }
                $chart_title=$("<div><input type='text' class='chart_title' placeholder='SN:0000'></div>").attr('ID','x_title'+cntChart)
                //plotarea.append($chart_title)
                if(ch=='mean'){
                    plotarea.append("<h3>2. Mean Q map</h3>")
                    //plotarea.before($('.printhead').clone())
                }else{
                    plotarea.append($chart_title)
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
                
                $('#xleg'+cntChart).prepend("<p class='legend_title'>RailP. [hpa]</p>")
                plotarea.find('.xplot').append($("<div class='zoom'></div>"))
                $.plot(plotarea.find('.zoom') , dataframe,optionsmall);
                if(cntChart==0){
                    plotarea.after($('#sign').clone().show())
                }
                cntChart++
            }
            plot_all();
            dcm_plot();
            plot_summary();
            
            $('h3').each(function(i,e){
                var $content=$('.printhead').clone()[0].outerHTML
                //console.log(i)
                if((i+1) % 2 == 0){       
                    $(this).parent('div').before($($content).css({'page-break-before': 'always'}))               
                }
            })
            $('#sign').after($('.printhead').clone()[0].outerHTML)
            function plot_all(){
                alldata=$.parseJSON(json_str)['plots'] //raw data
                plotarea=$("<div width='800'></div>")
                //plotarea.before($('.printhead').clone())
                plotarea.append("<h3>3. Q map for all injectors</h3>")
                //plotarea.append("<h2 class='chart_title'>All</h2>") 
                plotarea.append("<div class='xplot'></div>")
                dataframe=[]
                colorlist=['#E20015', '#B90276', '#50237F', '#005691', '#BFC0C2', '#008ECF', '#00A8B0', '#78BE20', '#006249','#525F6B','#EA6876','#D067AD','#967CB1','#6d9abc','#D7D7DA','#6FB9E2']
                colorindex=0
                //cntChart = alldata.length //dataset count
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
                
                $h=($("<ul id='allleg'></ul>"))
                if(colorindex==1){
                    len=1
                }else{
                    len=colorindex-1
                }
                for(var u = 0;u<len;u++){
                    $h.append($("<li class='allleg'><span style='border-color:# !important'></span><input type='text' class='input_legend' placeholder='SN:0000'></li>".replace(/#/g,colorlist[u])))
                }
                

                /*
                $h=$("<ul id='allleg'></ul>").append($("<li class='allleg leg_red'><span id='red_sq'></span><input type='text' class='input_legend' placeholder='i1'></li>"))
                $h.append($("<li class='allleg leg_green'><span id='green_sq'></span><input type='text' class='input_legend' placeholder='i2'></li>"))
                $h.append($("<li class='allleg leg_blue'><span id='blue_sq'></span><input type='text' class='input_legend' placeholder='i3'></li>"))
                $h.append($("<li class='allleg leg_blck'><span id='black_sq'></span><input type='text' class='input_legend' placeholder='i4'></li>"))
                */
                plotarea.append($("<div class='xleg'></div>").attr('ID','xleg'+cntChart))
                xoptions=options;
                xoptions.legend.container=$('#xleg'+cntChart)
                $.plot(plotarea.find('.xplot') , dataframe,xoptions);
                $('#xleg'+cntChart).append($h)
                $h.before($("<p class='legend_title'>Injector list</p>"))
                //$.plot(plotarea.find('.xplot') , dataframe,xoptions);
            }

            function dcm_plot(){
                dcm=$.parseJSON(json_str)['DCM']
                plotarea=$("<div width='800'></div>").css('overflow','auto')
                
                plotarea.append($("<h3>4. ET MAP </h3>").append(function(){
                    if(dcm){
                        return $("<span onclick='exportTableToCSV()' class='lbLoad'>Download DCM</span>")
                    }
                    else
                        return ""
                }))
                
                plotarea.append(dcm)
                
                $('#pic').append(plotarea)
                
                $('.dataframe td,th').text(function (){

                    txt=$(this).text()
                    if(txt*1>=100000){
                        return txt*1/1000
                    }else if(txt==""){
                        return ""
                    }else{
                        if(txt*1>4000){
                            return 4000;
                        }
                        return Math.round($(this).text()*10)/10
                    }
                    
                })
            }
            function plot_summary(){
                //summary="To ensure the accuracy, the mean value injector with SN:0037 is measured three times. In the Q-MAP of all measurings, it shows normal behavior and good repeatibility concerning injection quantity.The ET-MAP created is based on the average value of mean value injector measured."
                // summary must be input by users.
                plotarea=$("<div width='800px' height='300px'></div>").addClass('summary')
                plotarea.append("<h3>5. Summary</h3>")
                plotarea.append($("<div width='800px' ></div>").html("<textarea placeholder='Enter summay here' class='txt' cols='108' rows='4'></textarea>"+"<br><br>RBCD/ESD1<br><br> <input placeholder='Your Name' class='inputname'></input>"))
                
                $('#pic').append(plotarea)
                //plotarea.before($('.printhead').clone())
                /* Change to input directly no need to dblclick
                $('.editarea_d').dblclick(function(){
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
                $('span.sedit_d').on('dblclick',function(){
                    //alert('aa')
                    if($(this).hasClass('editing')){
                        return;
                    }
                    
                    newele=$('<input type="text">').attr('value',$(this).text()).blur(function(){
                        //return;
                        var val=$(this).val()
                        $(this).parent('span').text(val).removeClass('editing')
                    })//.addClass('inlineedit')
                    
                    //$(this).text("")
                    $(this).html(newele)
                    $(this).addClass('editing')
                    newele.focus()
                })
                */
                plotarea=$("<div width='800'></div>").addClass('recp')
                
                $att=$("<label for='getatt' class='lbLoad'> [Click Here to load image]</label>")
                $file=$("<input type='file' id='getatt'>").hide().change(function(){
                    //console.log("$file Changed!")
                    var file = $(this)[0].files[0];
                    var reader  = new FileReader();

                    // When the image is loaded we will set it as source of
                    // our img tag
                    reader.onloadend = function () {
                        //console.log("loaded..",reader.result)
                        $('#droppic').html($('<img>').attr('src',reader.result).css({'border':'0px',
                        'width':'800px',
                        'max-height':'833px',
                        'overflow':'hidden'}));
                    }
                    if (file) {
                        // Load image as a base64 encoded URI
                        reader.readAsDataURL(file);
                    }
                })
                plotarea.append($("<h3>6. Attachment-Test Sepcification</h3>").append($att,$file))

                
                //plotarea.append($att,$file)

                /**********************
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
                        var imageType = /image.*+/;

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
                )
                ************************/
                plotarea.append($("<div id='droppic'></div>").height(300).width(800)) //end append
                $('#pic').append(plotarea)
            }

            $('#info').show() //report header show after the process is finished.
        }

        

        </script>
        </head>

        <body>
        <div id='logo'><div id='siteinfo'></div><div id='bosch_logo'></div></div>
        
        
        <div width='80%' align='center' class='labelbox' >
            <div id='start' class='lb'>Click here to start</div>
            <label for="uploadbox" class='label'>Click here to start</label>
            <input type="file" name="photo" id="uploadbox" multiple="true" />
            <label id='savebox' class='btn'>Save Config file</label>
            <label for='loadbox' class='btn'>Load Config file</label>
            <input type="file" id="loadbox" multiple="false" />
        </div>
       
        <div class="printhead"><div style='width:672px;height:68px;float:left;line-height:68px;text-align:left'>Confidential</div><div class='logo'><img src="/css/logo.png" style='width:128px;height:68px'></div>
            <div class='ETMAP' style='width:600;float:left'>ET_MAP Measurement</div><div style='width:200px;float:right;text-align:right'>RBCD/ESD1</div>
        </div>
        <div id='intro'><video width='800px' height='600px' controls poster='/css/post.png' autoplay='false'><source src='/css/Intro.mp4' type="video/mp4"></video></div>
        <div id='qlist'></div>
        
        <div id='info' style="margin:2px auto;width:800px;text-align:center">
        <div style='text-align:right'>Issue_01</div>
        <table border style='border-collapse:collapse;width:100%'>
        <tbody>
            <tr>
                <td>Topic</td>
                <td colspan='5' ><input class='form' value='Q_MAP & ET_MAP for xxx'></td>
            </tr>
            <tr>
                <td>Description</td>
                <td colspan='5' ><input class='form' value='ET_MAP measured is used for xxx'></td>

            </tr>
            <tr>
                <td>System</td>
                <td colspan='5'><input class='form' value='CRSX-XX'></td>
            </tr>
            <tr>
                <td>Injectors</td>
                <td>Part number</td>
                <td><input class='form' value='B445 000 000'></td>
                <td>Serial number</td>
                <td colspan=2 style='box-sizing:border-box'><input class='form' value='' placeholder='mean' style='width:33%;float:left;border-right:1px dashed black'> <input style='width:66%;float:left;' class='form' value='' placeholder='others'></td>
                <!--<td><input class='form' value='' placeholder='others'></td>-->
            </tr>
            <tr>
                <td>Nozzle </td>
                <td>Flow rate</td>
                <td colspan='2'><input class='form' value='000 cm^3/30s@100bar'></td>
                <td>Needle lift</td>
                <td><input class='form' value='000 mm'></td>
                
            </tr>
            <tr>
                <td>Nz. Type</td>
                <td><input class='form' placeholder='Ks'></td>
                <td>DSP</td>
                <td><input class='form' value='000 mm'></td>
                <td>Holes num</td>
                <td><input class='form' value='0'></td>
            </tr>
            <tr>
                <td>Test No.</td>
                <td><input class='form' placeholder='YY/000'></td>
                <td>Date</td>
                <td><input class='form' placeholder='YYYY.MM.DD'></td>
                <td>Reference</td>
                <td><input class='form' placeholder='Your Name'></td>
            </tr>

        </tbody>
        <!--
                    <tbody>
            <tr>
                <td>Topic</td>
                <td colspan='5' class='edit'>Q_MAP & ET_MAP for DCD NGE3.1</td>
            </tr>
            <tr>
                <td>Description</td>
                <td colspan='5' class='edit'>ET_MAP measured is used for nozzle definition and engine first firing in B sample</td>

            </tr>
            <tr>
                <td>System</td>
                <td colspan='5' class='edit'>CRS1-18</td>
            </tr>
            <tr>
                <td>Injectors</td>
                <td>Part number</td>
                <td class='edit'>B445113591</td>
                <td>Serial number</td>
                <td class='edit'>0081</td>
                <td class='edit'>0091,0093,0095</td>
            </tr>
            <tr>
                <td>Nozzle needle lift</td>
                <td class='edit'>0.87mm</td>
                <td>Nozzle flow rate</td>
                <td class='edit'>480cm^3/30s@100bar</td>
                <td>DSP</td>
                <td class='edit'>0.123mm/8hole</td>
            </tr>
            <tr>
                <td>Test number</td>
                <td class='edit'>18/088</td>
                <td>Date</td>
                <td class='edit'>2018.07.12</td>
                <td>Reference</td>
                <td class='edit'>Rong Yiyi</td>
            </tr>

        </tbody>
        -->
        </table>
        </div>
        
        <div id="pic"></div>
        <div style="height:50px;width:100%;position:relative;bottom:10px" id='foot'> </div>


        <div style="display:none;width:800px" id='sign'>
        <table style="width:100%">
        <tr>
            <td width='90'>SM:</td>
            <td width='80'>RBCD/ESD1</td>
            <td width='70'>Phone:</td>
            <td width='100'>+86 510 8110 6670</td>
            <td width='60'>Date:</td>
            <td width='80'></td>
            <td width='80'>Signature:</td>
            <td width='80'></td>
        </tr>
        <tr>
            <td>DM:</td>
            <td>RBCD/ESD</td>
            <td>Phone:</td>
            <td>+86 510 8533 5300</td>
            <td>Date:</td>
            <td></td>
            <td>Signature:</td>
            <td></td>
        </tr>
        <tr>
            <td colspan='2'>Note(s):</td>
            <td colspan='2'>--</td>
            <td colspan='2'>Report sent to the customer: </td>
            <td colspan='2'>Internal</td>

        </tr>
        </table>
        </div>

        


        </body>
        </html>