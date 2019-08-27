function downloadCSV(csv, filename) {
    var csvFile;
    var downloadLink;

    // CSV file
    csvFile = new Blob([csv], {type: "text/csv"});

    // Download link
    downloadLink = document.createElement("a");

    // File name
    downloadLink.download = filename;

    // Create a link to the file
    downloadLink.href = window.URL.createObjectURL(csvFile);

    // Hide download link
    downloadLink.style.display = "none";

    // Add the link to DOM
    document.body.appendChild(downloadLink);

    // Click download link
    downloadLink.click();
}

function exportTableToCSV() {
    var filename='30-000000_PROJECT_ET-MAP_B-sample_PN_00_NAME_DATE.DCM'
    var csv = ['**** This file is generated by web based tool ET_MAP designed by RBCD\/ESD1',
        '**** If there is any problem please contact zhongji.tang@cn.bosch.com',
        'KONSERVIERUNG_FORMAT 2.0',
		'KENNFELD InjVlv_tiET_MAP #SIZE#',
		'LANGNAME ""',
		'EINHEIT_X "hPa"',
		'EINHEIT_Y "mm^3/inj"',
		'EINHEIT_W "us"'];
    var rows = document.querySelectorAll("table.dataframe tr");
    
    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll("td, th");
        if(i==0){
            row.push('ST/X')
            for (var j = 1; j < cols.length; j++){
                if(cols[j].innerText){
                    row.push(cols[j].innerText*1000);
                }
            }
        }
        else{
            for (var j = 0; j < cols.length; j++){
                if(j==0){
                    row.push('ST/Y')
                    row.push(cols[j].innerText)
                    csv.push(row.join(" "))
                    row=[]
                }
                else if(j==1){
                    row.push('WERT')
                    row.push(cols[j].innerText);
                }else{
                    row.push(cols[j].innerText);
                }
            }
        }
        csv.push(row.join(" "));        
    } //end for i
    csv.push("END")
    // Download CSV file
    downloadCSV(csv.join("\r\n").replace("#SIZE#",(cols.length-1)+" "+(rows.length-1)), filename);
}