// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function filter(selector, query) {  
  query = $.trim(query); //trim white space  
  query = query.replace(/ +/gi, '|'); //add OR for regex query (prefer to add AND but tricky with regex)

  $(selector).each(function() {  
    if ($(this).text().search(new RegExp(query, "i")) < 0) {  
       $(this).hide();
     } else {  
      $(this).show();
     }
  });  
}


function setupFilter(row_selector) {
  $('#filter').keyup(function(event) {  
    if (event.keyCode == 27 || $(this).val() == '') {  
      $(this).val('');  
      $(row_selector).show();  
    } else {  
      filter(row_selector, $(this).val());  
    }
  });
}  
