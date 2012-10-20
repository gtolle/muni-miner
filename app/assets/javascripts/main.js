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
		"#00FF00"];

$(document).ready(function() {
    var initialLat;
    var initialLng;
    var initialZoom;
    
    if ( initialLat == null ) { initialLat = 37.77493; }
    if ( initialLng == null ) { initialLng = -122.419415; }
    if ( initialZoom == null ) { initialZoom = 13; }
    
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
    
    showRoute();
});

function showRoute() {
    $.getJSON('/main/route.json',
	      { 
		  route: '33',
		  direction: 0,
		  trip_date: '2012-09-01',
		  trip: 1150
	      },
	      renderRoute);
}

function renderRoute(stops) {
    clearLines();

    var lastStop = stops[0];
    var max = 0;
    var min = 0;

    var metricName = "psgr_load";
    //var metricName = "dep_dev_mins";

    $.each(stops, function( idx, stop ) {
	var metric = parseFloat(stop[metricName]);
	if ( metric > max ) {
	    max = metric;
	}
	if ( metric < min ) {
	    min = metric;
	}
    });

    var range = max - min;

    console.log(max, min, range);

    var metric;
    
    var stop = stops[0];
    metric = parseFloat(stop[metricName]);

    for( var i = 1; i < stops.length; i++ ) {
	var stop = stops[i];
	if (stop[metricName]) {
	    metric = parseFloat(stop[metricName]);
	}
	var normalized = (metric - min) / range;

	var opacity = normalized;
	var blue = "#0044FF";

	var gradient_idx = Math.floor(normalized * (gradient.length-1));
	var color = gradient[gradient_idx];

	console.log(i, stop.stop_seq_id, stop.latitude, stop.longitude, metric, normalized, gradient_idx, color);

        var pl = new google.maps.Polyline({
            map: map,
            clickable: false,
            strokeOpacity: opacity,
            strokeWeight: 5,
            strokeColor: blue,
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

