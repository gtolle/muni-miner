var map;
var lines = [];
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

var route;
var direction;
var trip_date;
var trip;

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
    $.getJSON('/main/trips.json',
	      {
		  route: route,
		  direction: direction
	      }, 
	      renderTrips);
}

function renderTrips(trips) {
    $("#trips").empty();
    $.each(trips, function( idx, trip ) {
	$("#trips").append('<li><a href="#" class="trip_link" data-trip-date="' + trip.trip_date + '" data-trip="' + trip.trip + '">' + trip.trip_date + ' ' + trip.trip + ' (' + trip.stops + ' stops)</a></li>');
    });
    $(".trip_link").click(function(e) {
	var obj = $(this);
	$("#trips a").removeClass("selected");
	obj.addClass("selected");
	showTrip( route, direction, obj.data('trip-date'), obj.data('trip') );
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

function renderTrip(stops) {
    clearLines();

    var lastStop = stops[0];
    var max = 0;
    var min = 0;

    //var metricName = "psgr_load";
    var metricName = "dep_dev_mins";

    min = -5;
    max = 5;
    
    /*
    min = -1;
    max = 1;
    */

    /*
    $.each(stops, function( idx, stop ) {
	var metric = parseFloat(stop[metricName]);
	if ( metric > max ) {
	    max = metric;
	}
	if ( metric < min ) {
	    min = metric;
	}
    });
    */

    var range = max - min;

    //console.log(max, min, range);

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
            strokeWeight: 5,
            strokeColor: color,
            path: [ new google.maps.LatLng( lastStop.latitude, -lastStop.longitude ),
                    new google.maps.LatLng( stop.latitude, -stop.longitude ) ]
        });

	lines.push(pl);
	lastStop = stop;
    }
}

function clearLines() {
    for( var i = 0; i < lines.length; i++ ) {
        var line = lines[i];
        line.setMap(null);
    }

    lines = [];
}

