var gradient = ["#FF0000",
		"#F30C00",
		"#E71800",
		"#DB2400",
		"#CF3000",
		"#C33C00",
		"#B74800",
		"#AB5400",
		"#9F6000",
		"#936C00",
		"#877800",
		"#7B8400",
		"#6F9000",
		"#639C00",
		"#57A800",
		"#4BB400",
		"#3FC000",
		"#33CC00",
		"#27D800",
		"#1BE400",
		"#0FF000",
		"#00FF00",
		"#00F30C",
		"#00E718",
		"#00DB24",
		"#00CF30",
		"#00C33C",
		"#00B748",
		"#00AB54",
		"#009F60",
		"#00936C",
		"#008778",
		"#007B84",
		"#006F90",
		"#00639C",
		"#0057A8",
		"#004BB4",
		"#003FC0",
		"#0033CC",
		"#0027D8",
		"#001BE4",
		"#000FF0",
		"#0000FF"];

var map;

var route;
var direction;
var trip_date;
var trip;
var stops;

var delaychange;

var lines = [];
var circles = [];
var markers = [];

$(document).ready(function() {
    var initialLat;
    var initialLng;
    var initialZoom;
    
    if ( initialLat == null ) { initialLat = 37.77493; }
    if ( initialLng == null ) { initialLng = -122.419415; }
    if ( initialZoom == null ) { initialZoom = 12; }
    
    var initialLatLng = new google.maps.LatLng( initialLat, initialLng );
    console.log(initialLatLng);
    
    var myOptions = {
	zoom: initialZoom,
	center: initialLatLng,
	mapTypeId: google.maps.MapTypeId.ROADMAP,
	scaleControl: true
    };
    
    var canvas = document.getElementById("map");
    map = new google.maps.Map(canvas, myOptions);

    delaychange = "dep_dev_mins_diff";

    $(".delaychange").change(function(e) {
	delaychange = this.value;
	renderTrip(stops);
    });

    getRoutes();
});

function getRoutes() {
    $.getJSON('/main/routes.json',
	      renderRoutes);
}

function renderRoutes(routes) {
    $("#routes").empty();

    $.each(routes, function( idx, route ) {
	$("#routes").append('<li><a href="#" class="route_link" data-route="' + route.route + '" data-direction="' + route.direction + '">' + route.route + ' ' + (route.direction == 0 ? "Outbound" : "Inbound" ) + '</a></li>');
    });

    $(".route_link").click(function(e) {
	var obj = $(this);
	$("#routes a").removeClass("selected");
	obj.addClass("selected");
	route = obj.data('route');
	direction = obj.data('direction');
	getTrips( obj.data('route'), obj.data('direction') );
    });
}

function getTrips(route, direction) {
    trip_date = null;
    trip = null;

    clearLines();
    clearCircles();
    clearMarkers();

    $.getJSON('/main/trips.json',
	      {
		  route: route,
		  direction: direction
	      }, 
	      renderTrips);

    $.getJSON('/main/worst_stops.json',
	      {
		  route: route,
		  direction: direction
	      }, 
	      renderWorstStops);
}

function renderTrips(trips) {
    $("#trips").empty();
    $.each(trips, function( idx, trip ) {
	$("#trips").append('<li><a href="#" class="trip_link" data-trip-date="' + trip.trip_date + '" data-trip="' + trip.trip + '">' + trip.act_dep_time + '</a></li>');
    });
    $(".trip_link").click(function(e) {
	var obj = $(this);
	$("#trips a").removeClass("selected");
	obj.addClass("selected");
	showTrip( route, direction, obj.data('trip-date'), obj.data('trip') );
    });
}

function renderWorstStops(worstStops) {
    $("#worststops").empty();

    clearMarkers();

    $.each(worstStops, function( idx, stop ) {
	$("#worststops").append('<li>' + stop.stop_name + '</li>');
	
        var marker = new google.maps.Marker({
            map: map,
            clickable: false,
            position: new google.maps.LatLng( stop.latitude, -stop.longitude )
        });

	markers.push(marker);
    });
}

function showTrip(route, direction, trip_date, trip) {
    $.getJSON('/main/trip.json',
	      { 
		  route: route,
		  direction: direction,
		  trip_date: trip_date,
		  trip: trip
	      },
	      renderTrip);
}

function renderTrip(stopsPassed) {
    clearLines();

    stops = stopsPassed;

    var lastStop = stops[0];
    var max = 0;
    var min = 0;

    var metricName;

    if (delaychange == "dep_dev_mins_interp") {
	var metricName = "dep_dev_mins_interp";
	min = -10;
	max = 10;
    } else {
	var metricName = "dep_dev_mins_diff";
	min = -4;
	max = 4;
    }

    var range = max - min;

    var stop = stops[0];

    for( var i = 1; i < stops.length; i++ ) {
	var stop = stops[i];
	var metric = parseFloat(stop[metricName]);

	if (metric < min) { metric = min; }
	if (metric > max) { metric = max; }

	var normalized = (metric - min) / range;

	var opacity = normalized;
	var blue = "#0044FF";

	var gradient_idx = Math.floor(normalized * (gradient.length-1));
	var color = gradient[gradient_idx];

	//console.log(i, stop.stop_seq_id, stop.latitude, stop.longitude, metric, normalized, gradient_idx, color);

        var pl = new google.maps.Polyline({
            map: map,
            clickable: false,
            strokeOpacity: 0.8,
            strokeWeight: 8,
            strokeColor: color,
            path: [ new google.maps.LatLng( lastStop.latitude, -lastStop.longitude ),
                    new google.maps.LatLng( stop.latitude, -stop.longitude ) ]
        });

	lines.push(pl);
	lastStop = stop;
    }

    renderMetric();
}

function renderMetric() {
    clearCircles();

    $.each(stops, function( idx, stop ) {

	// var metric = stop.psgr_load;
	var metric = stop.psgr_on + stop.psgr_off;
	
	var normalized = metric / 30;
	var radius = 500 * normalized;

	console.log(metric, normalized, radius);

	var c = new google.maps.Circle({
	    map: map,
	    clickable: false,
	    center: new google.maps.LatLng( stop.latitude, -stop.longitude ),
	    radius: radius,
	    strokeColor: "#0044FF",
	    strokeOpacity: 0.2,
	    strokeWeight: 3,
	    fillColor: "#0044FF",
	    fillOpacity: 0.2
	});

	circles.push(c);
    });
}

function clearLines() {
    for( var i = 0; i < lines.length; i++ ) {
        var line = lines[i];
        line.setMap(null);
    }

    lines = [];
}

function clearCircles() {
    for( var i = 0; i < circles.length; i++ ) {
        var circle = circles[i];
        circle.setMap(null);
    }

    circles = [];
}

function clearMarkers() {
    for( var i = 0; i < markers.length; i++ ) {
        var marker = markers[i];
        marker.setMap(null);
    }

    markers = [];
}
