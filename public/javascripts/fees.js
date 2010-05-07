new_member = null;
category = null;
adults = null;
children = null;		
items = null;
top_racks = null;
middle_racks = null;
bottom_racks = null;
minnow_racks = null;

function set_nm(nm) {
	new_member = nm;
	$('#member_category').show();
	caltotal();
}

function set_cat(c) {
	if(c == 'family') {
		$('#family_members').show();
	} else {
		$('#family_members').hide();
	}
	
	category = c;
	caltotal();
}

function set_adults(a) {
	adults = a;
	caltotal();
}

function set_children(c) {
	children = c;
	caltotal();
}

function set_top_racks(tr) {
  top_racks = tr;
  $('#middle_racks').show();
  caltotal();
}

function set_middle_racks(tr) {
  middle_racks = tr;
  $('#bottom_racks').show();
  caltotal();
}

function set_bottom_racks(tr) {
  bottom_racks = tr;
  $('#minnow_racks').show();
  caltotal();
}

function set_minnow_racks(tr) {
  minnow_racks = tr;
  caltotal();
}

function category_and_family_setup() {
  result = category != null && (category != 'family' || (category == 'family' && adults != null && children != null))
  if(result) {
    $('#racking_fees').show();
  } else {
    $('#racking_fees').hide();
  }
  return result;
}

function racking_choosen() {
return top_racks != null && middle_racks != null && bottom_racks != null && minnow_racks != null;
}

function top_rack_fees() {
	return 115 * top_racks;
}

function middle_rack_fees() {
	return 150 * middle_racks;
}

function bottom_rack_fees() {
	return 190 * bottom_racks;
}

function minnow_rack_fees() {
	return 75 * minnow_racks;
}

function racking_fees() {
  return top_rack_fees() + middle_rack_fees() + bottom_rack_fees() + minnow_rack_fees();
}

function caltotal() {		  
	if(new_member != null && category_and_family_setup() && racking_choosen()) {
		total = 0;
        description = "";

		total += joining_fee();
		total += annual_subcription();
		total += vy_levy();
		total += racking_fees();
				
		if(new_member) {
		  description = 'joining ($' + joining_fee() + ') + ';
	  } else {
	    description = '';
	  }
	  
	  description += category + ' ($' + (annual_subcription() + vy_levy()) + ')';
	  
	  if(top_racks > 0) {
	    description += ' + ' + top_racks + ' top ($' + top_rack_fees() + ')';
	  }

	  if(middle_racks > 0) {
	    description += ' + ' + middle_racks + ' middle ($' + middle_rack_fees() + ')';
	  }

	  if(bottom_racks > 0) {
	    description += ' + ' + bottom_racks + ' bottom ($' + bottom_rack_fees() + ')';
	  }

	  if(minnow_racks > 0) {
	    description += ' + ' + minnow_racks + ' minnow ($' + minnow_rack_fees() + ')';
	  }
				
		$('#total_output').html('$' + total);
		$('#total_description').html(description);
		$('#payal_button').show();
		$('#paypal_item_name').value = description;
		$('#paypal_value').value = total;
	} else {
		$('#total_output').html('(waiting for selections)');
		$('#total_description').html('');
		$('#payal_button').hide();
	}
}

function joining_fee() {
	if(new_member) {
		switch(category) {
			case 'family':
			case 'senior':
				return 75;
			case 'junior':
			case 'student':
			case 'pensioner':
				return 30;
			case 'associate':
				return 10;
		}
	} else {
		return 0;
	}
}

function annual_subcription() {
	switch(category) {
		case 'family':
			return 360;
		case 'senior':
			return 235;
		case 'junior':
			return 100;
		case 'student':
			return 150;
		case 'pensioner':
			return 150;
		case 'associate':
			return 50;
	}
}

function vy_levy() {
	switch(category) {
		case 'family':
			return 0.00 * adults + 0.00 * children;
		case 'senior':
			return 0.00;
		case 'junior':
			return 0.00;
		case 'student':
			return 0.00;
		case 'pensioner':
			return 0.00;
		case 'associate':
			return 0;
	}
}