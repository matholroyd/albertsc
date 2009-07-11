two_senior_boat = null;
seniors = null;
students = null;
juniors = null;
category = null;
items = null;
top_racks = null;
middle_racks = null;
minnow_racks = null;

function set_tsb(v) {
	two_senior_boat = v;
	$('seniors').show();
	caltotal();
}

function set_seniors(v) {
	seniors = v;
	$('students').show();
	caltotal();
}

function set_students(v) {
	students = v;
	$('juniors').show();
	caltotal();
}

function set_juniors(v) {
	juniors = v;
	$('racking_fees').show();
	caltotal();
}

function set_top_racks(tr) {
  top_racks = tr;
  $('middle_racks').show();
  caltotal();
}

function set_middle_racks(tr) {
  middle_racks = tr;
  $('bottom_racks').show();
  $('minnow_racks').show();
  caltotal();
}

function set_minnow_racks(tr) {
  minnow_racks = tr;
  caltotal();
}

function membership_choosen() {
  return two_senior_boat != null && seniors != null && students != null && juniors != null;
}

function membership_fees() {
	return two_senior_boat * 90 + seniors * 70 + students * 40 + juniors * 40;
}

function racking_choosen() {
  return top_racks != null && middle_racks != null && minnow_racks != null;
}

function racking_fees() {
  return top_racks * 50 + middle_racks * 65 + minnow_racks * 20;
}

function caltotal() {		  
	if(membership_choosen() && racking_choosen()) {
		total = 0;
    description = "";

		total += membership_fees();
		total += racking_fees();

		description += 'winter membership ($' + membership_fees() + ')'
		if(racking_fees() > 0) {
			description += ' + winter racking ($' + racking_fees() + ')'
		}
				
		$('total_output').innerHTML = '$' + total;
		$('total_description').innerHTML = description
		$('payal_button').show();
		$('paypal_item_name').value = description
		$('paypal_value').value = total
	} else {
		$('total_output').innerHTML = '(waiting for selections)';
		$('total_description').innerHTML = ''
		$('payal_button').hide();
	}
}





}