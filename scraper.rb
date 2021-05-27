# <?php
# set_include_path(get_include_path() . PATH_SEPARATOR . '../scraperwiki-php/');
#
# require 'scraperwiki.php';
#
# date_default_timezone_set('Australia/Hobart');
#
# require 'simple_html_dom.php';
#
# $url = 'http://www.huonvalley.tas.gov.au/services/planning-2/planningnotices/';
#
# function removeSuffix($target, $suffix) {
#     $trimmedTarget = $target;
#     $pos = strrpos($target, $suffix);
#     if ($pos) {
#         $trimmedTarget = substr($trimmedTarget, 0, $pos);
#     }
#     return $trimmedTarget;
# }
#
# $dapage = $url;
# $html = scraperwiki::scrape($dapage);
# $dom = new simple_html_dom();
# $dom->load($html);
# $darow = $dom->find("/html/body/div/main/table/tbody/tr");
# foreach ($darow as $thisrow) {
#     //<tr>
#     //	<td>DA-6-2015 - Dwelling and Carport - Land - (CT128515-1) directly to the south of 14 Smyley Street, Franklin</td>
#     //    <td>Smyley Street, Franklin, Tasmania, Australia</td>
#     //	  <td>15 Sep 2015</td>
#     //    <td>29 Sep 2015</td>
#     //    <td>
#     //		<a class="btn-sm btn btn-primary" href="https://drive.google.com/open?id=0B4M5kQr8ve_Gamx2dmtLbjZmY28" style="margin-bottom: 3px; margin-right: 3px;">Copy of Plans for display	</a>
#     //	</td>
#     //</tr>
#     $record = array();
#     $cells = $thisrow->find("td");
# //Although this specifies tbody is still returns the thead/tr row so I have to delete it
#     if (sizeof($cells) > 0) {
#         $refdesc = $cells[0]->plaintext;
#         $delim = ' - ';
#         //just use space as sometimes not ' - '
#         $delimpos = stripos($refdesc, ' ');
#         $record['council_reference'] = substr($refdesc, 0, $delimpos);
#         $address = $cells[1]->plaintext;
# //can't just use length of delim as don't know how many space of hyphen to strip
#         $description = trim(substr($refdesc, $delimpos + 1), ' -');
# //remove address from end of description, if it's there
#         $description = removeSuffix($description, $delim . $address);
# //sometimes address has Tasmania, Australia on the end
#         $address = removeSuffix($address, ', Australia');
#         $description = removeSuffix($description, $delim . $address);
# //sometimes address has just Tasmania on the end
#         $address = removeSuffix($address, ', Tasmania');
# //description sometimes includes address with a space-hyphen-space before
#         $description = removeSuffix($description, $delim . $address);
#         $record['address'] = htmlspecialchars_decode($address . ', Tasmania');
#         $record['description'] = htmlspecialchars_decode($description);
#         $record['date_received'] = date('Y-m-d', strtotime($cells[2]->plaintext));
#         $record['on_notice_to'] = date('Y-m-d', strtotime($cells[3]->plaintext));
#         $record['info_url'] = $cells[4]->find('a')[0]->href;
#         $record['comment_url'] = 'http://www.huonvalley.tas.gov.au/services/planning-2/how-to-make-a-representation/';
#         $record['date_scraped'] = date('Y-m-d');
#     }
#     print ("Saving record " . $record['council_reference'] . "\n");
# //        print_r ($record);
#     scraperwiki::save_sqlite(array('council_reference'), $record, 'data');
# }
# ?>
