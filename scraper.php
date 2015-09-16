<?php

require 'scraperwiki.php';

date_default_timezone_set('Australia/Hobart');

require 'simple_html_dom.php';

$url = 'http://www.huonvalley.tas.gov.au/services/planning-2/planningnotices/';

$dapage = $url;
$html = scraperwiki::scrape($dapage);
$dom = new simple_html_dom();
$dom->load($html);
$darow = $dom->find("table#list tbody tr");
print 'number of records: ' . sizeof($darow);
foreach ($darow as $thisrow) {
//<tr>
//	<td>DA-6-2015 - Dwelling and Carport - Land - (CT128515-1) directly to the south of 14 Smyley Street, Franklin</td>
//    <td>Smyley Street, Franklin, Tasmania, Australia</td>
//	  <td>15 Sep 2015</td>
//    <td>29 Sep 2015</td>
//    <td>
//		<a class="btn-sm btn btn-primary" href="https://drive.google.com/open?id=0B4M5kQr8ve_Gamx2dmtLbjZmY28" style="margin-bottom: 3px; margin-right: 3px;">Copy of Plans for display	</a>                                
//	</td>
//</tr>
 // var_dump($thisrow);

    $record = array();
	$cells = $thisrow->find("td");
	
	var_dump($cells);
	
	$refdesc = $cells[0];
	$delim = ' - ';
	$delimpos = stripos($refdesc, $delim);
    $record['council_reference'] = substr($refdesc, 0, $stripos - 1);
	$record['description'] = substr($refdesc, $stripos + strlen(delim));
	$record['address'] = $cells[1];
	$record['date_received'] = $cells[2];
	$record['on_notice_to'] = date('Y-m-d', $cells[3]);
	$record['info_url'] = $cells[4]->find('a')->href;
    $record['comment_url'] = 'http://www.huonvalley.tas.gov.au/services/planning-2/how-to-make-a-representation/';
    $record['date_scraped'] = date('Y-m-d');

//    var_dump($record);
    
//    $existingRecords = scraperwiki::select("* from data where `council_reference`='" . $record['council_reference'] . "'");
//    if (count($existingRecords) == 0) {
//        print ("Saving record " . $record['council_reference'] . "\n");
        //print_r ($record);
        scraperwiki::save_sqlite(array('council_reference'), $record, 'data');
//    } else {
//        print ("Skipping already saved record " . $record['council_reference'] . "\n");
//    }
}
?>