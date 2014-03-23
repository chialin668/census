/*
    MarkerReducer.js - Another one of Marker Manager instead of GMarkerManager
    $Revision: 63 $
    (c) 2007 WATANABE Hiroaki <hwat at mac dot com>
    This is distributed under the MIT license.
*/
/***************************************
    Extends GLatLng ... these are fake methods but important.
*/
GLatLng.prototype.getPoint = function (){return this;}
GLatLng.prototype.show = function (){}
GLatLng.prototype.hide = function (){}
GLatLng.prototype.isHidden = function (){return true;}
/***************************************
    Class MarkerReducer
*/
var MarkerReducer = function(/*GMap2*/map,/*MarkerReducerOptions*/opts){
    opts = opts || {};
    this.debug;
    this.revision = '$Revision: 63 $'.match(/(\d+)/) ? RegExp.$1 : '';
    this.map = map;
    this.packages = [];
    this.zoomExpand = {};
    //-- MarkerReducerOptions
    this.borderPadding = opts.borderPadding ? parseInt(opts.borderPadding) : 8; // pixel. span because of wrapping.
    this.maxZoom = opts.maxZoom ? parseInt(opts.maxZoom) : 19; // number. When the zoom level is more than the value, it doesn't make the wrapper.
    this.trackMarkers = opts.trackMarkers ? true : false; // MarkerReducer do the refresh on the GMarkers' movements. This property have to be set when construct.
    this.wrapperIcon = opts.wrapperIcon || null; // GIcon. If set to null that means default icon G_DEFAULT_ICON.
    this.packageFieldOptions = opts.packageFieldOptions || null; // Object. it need have properties for parameters of GPolygon.
    this.wrapperFieldOptions = opts.wrapperFieldOptions || null; // If set this to not Object, then it won't draw polygon.
    this.mapPadding = opts.mapPadding || 40; // pixel. on zoom-in triggerd by wrappers, that bounds fits into the map view with this padding.
    //-- initialize
    if( opts.debug ){
        this.enableDebug(true);
    }else{
        this.disableDebug();
    }
    GEvent.bind( this.map, 'zoomend', this, function (o,n){
        MarkerReducer.Logger.write("----- "+new Date());
        if( o == n ){
            void(0);
        }else{
            this.refresh(o,n);
        }
    } );
    GEvent.addListener( this.map, 'addoverlay', function (overlay){
        overlay._overlaied = true;
    } );
    GEvent.addListener( this.map, 'removeoverlay', function (overlay){
        overlay._overlaied = false;
    } );
    MarkerReducer.Logger.write('new MarkerReducer - rev: '+ this.revision);
}
MarkerReducer.Logger = {};
MarkerReducer.Logger.write = function (){};

MarkerReducer.FIELD_PROPERTIES_PACKAGE = {
    "strokeColor":"#999999",
    "strokeWeight":1,
    "strokeOpacity":0.5,
    "fillColor":"#cccccc",
    "fillOpacity":0.25
};
MarkerReducer.FIELD_PROPERTIES_WRAPPER = {
    "strokeColor":"#990000",
    "strokeWeight":1,
    "strokeOpacity":0.5,
    "fillColor":"#cc0000",
    "fillOpacity":0.25
};
MarkerReducer.GPolygonFromGLatLngBounds = function(/*GLatLngBounds*/b,strokeColor,strokeWeight,strokeOpacity,fillColor,fillOpacity){
    var pts = [];
    pts.push( new GLatLng( b.getSouthWest().lat(), b.getSouthWest().lng() ) );
    pts.push( new GLatLng( b.getSouthWest().lat(), b.getNorthEast().lng() ) );
    pts.push( new GLatLng( b.getNorthEast().lat(), b.getNorthEast().lng() ) );
    pts.push( new GLatLng( b.getNorthEast().lat(), b.getSouthWest().lng() ) );
    pts.push( pts[0] );
    return new GPolygon( pts, strokeColor, strokeWeight, strokeOpacity, fillColor, fillOpacity );
}
MarkerReducer.prototype.enableDebug = function (/*boolean*/force){
    if( ! this.debug || force ){ this.debug = {}; }
}
MarkerReducer.prototype.disableDebug = function (){
    this.debug = null;
}
MarkerReducer.prototype.getGBoundsOfMarkerField = function (/*MarkerReducer.Package*/pkg){
    var pt = this.map.fromLatLngToDivPixel( pkg.gmarker.getPoint() );
    var pt_sw   = new GPoint(pt.x - this.borderPadding, pt.y + this.borderPadding);
    var pt_ne   = new GPoint(pt.x + this.borderPadding, pt.y - this.borderPadding);
    pkg._gbounds = new GBounds( [pt_sw, pt_ne] );
    return pkg._gbounds;
}
MarkerReducer.prototype.getGLatLngBoundsOfMarkerField = function (/*MarkerReducer.Package*/pkg){
    var pt = this.map.fromLatLngToDivPixel( pkg.gmarker.getPoint() );
    var pt_sw   = new GPoint(pt.x - this.borderPadding, pt.y + this.borderPadding);
    var pt_ne   = new GPoint(pt.x + this.borderPadding, pt.y - this.borderPadding);
    var latlng_sw   = this.map.fromDivPixelToLatLng( pt_sw );
    var latlng_ne   = this.map.fromDivPixelToLatLng( pt_ne );
    pkg._glatlngbounds = new GLatLngBounds( latlng_sw, latlng_ne );
    return pkg._glatlngbounds;
}
MarkerReducer.prototype.getIntersectionCenterGLatLng = function (/*MarkerReducer.Package*/pkg1,pkg2){
    var b1 = pkg1._gbounds ? pkg1._gbounds : this.getGBoundsOfMarkerField( pkg1 );
    var b2 = pkg2._gbounds ? pkg2._gbounds : this.getGBoundsOfMarkerField( pkg2 );
    var is = GBounds.intersection(b1,b2);
    if( is.min().x < is.max().x || is.min().y < is.max().y ){
        return this.map.fromDivPixelToLatLng( new GPoint(
                is.minX + ((is.maxX - is.minX) / 2),
                is.minY + ((is.maxY - is.minY) / 2)));
    }else{
        return null;
    }
}
MarkerReducer.prototype._extendGLatLngBoundsContainsAllIntersects = function (/*GLatLngBounds*/b,/*MarkerReducer.Package*/pkg){
    for( var i = 0; i < pkg.intersects.length; ++i ){
        b.extend( pkg.intersects[i].gmarker.getPoint() );
        b = this._extendGLatLngBoundsContainsAllIntersects(b, pkg.intersects[i]);
    }
    return b;
}
MarkerReducer.prototype.fitMapContainsAllIntersects = function (/*MarkerReducer.Package*/pkg1,pkg2){
    var b = new GLatLngBounds(pkg1.gmarker.getPoint());
    b.extend(pkg2.gmarker.getPoint());
    b = this._extendGLatLngBoundsContainsAllIntersects(b, pkg1);
    b = this._extendGLatLngBoundsContainsAllIntersects(b, pkg2);
    if( this.debug ){
        if( this.debug.intersects_bounds instanceof GPolygon ){
            this.map.removeOverlay(this.debug.intersects_bounds);
        }
        this.debug.intersects_bounds = MarkerReducer.GPolygonFromGLatLngBounds(b,'#000099',1,0.5,'#ccccff',0.25);
        this.map.addOverlay(this.debug.intersects_bounds);
    }
    var width  = this.map.getSize().width  - this.mapPadding * 2;
    var height = this.map.getSize().height - this.mapPadding * 2;
    var z = this.map.getCurrentMapType().getBoundsZoomLevel(b, new GSize(width,height) );
    MarkerReducer.Logger.write('thinned:'+ z);
    this.map.setCenter(b.getCenter(),z);
}
/*--------------------------------------
    Public Methods
*/
MarkerReducer.prototype.onChangedGMarker = function (/*GMarker*/gmarker,/*GLatLng*/oldPoint,newPoint){
    this.refresh();
}
MarkerReducer.prototype.addMarker = function (/*GMarker*/gmarker, minZoom, maxZoom){
    minZoom = minZoom ||  0; // to do
    maxZoom = maxZoom || 19; // to do
    if( this.trackMarkers && gmarker instanceof GMarker ){
        GEvent.bind(gmarker, 'changed', this, this.onChangedGMarker);
    }
    var pkg = new MarkerReducer.Package( gmarker );
    this.packages.push( pkg );
    return pkg;
}
MarkerReducer.prototype.addMarkers = function (/*Array of GMarker*/gmarkers, minZoom, maxZoom){
    for( var i = 0; i < gmarkers.length; ++i ){
        this.addMarker( gmarkers[i], minZoom, maxZoom );
    }
    return this;
}
MarkerReducer.prototype.getMarkerCount = function (){ // count shown markers.
    var count = 0;
    for( var i = 0; i < this.packages.length; ++i ){
        if( ! this.packages[i].gmarker.isHidden() ){
            ++count;
        }
    }
    return count;
}
MarkerReducer.prototype.refresh = function (oldLevel,newLevel){
    var t1 = (new Date()).getTime();
    this.clearFields();
    var t2 = (new Date()).getTime();
    this.resets(oldLevel,newLevel);
    var t3 = (new Date()).getTime();
    MarkerReducer.Logger.write('refresh(): zoom level  : '+ this.map.getZoom() );
    MarkerReducer.Logger.write('refresh(): clear Fields: '+ (t2 - t1) +' ms');
    MarkerReducer.Logger.write('refresh(): reset()     : '+ (t3 - t2) +' ms');
    setTimeout( GEvent.callback( this, function (){
        var t4 = (new Date()).getTime();
        this.drawFields();
        var t5 = (new Date()).getTime();
        MarkerReducer.Logger.write('refresh(): draw Fields : '+ (t5 - t4) +' ms');
    } ), 1 );
}
/*--------------------------------------
    Private Methods
*/
MarkerReducer.prototype.resets = function (oldLevel,newLevel){
    var currentZoom = this.map.getZoom();
    if( isNaN(oldLevel) || isNaN(newLevel) ){
        oldLevel = currentZoom;
        newLevel = currentZoom;
    }
    var onZoomInOrRefresh = oldLevel <= newLevel ? true : false;
    //-- reset
    var t1 = (new Date()).getTime();
    for( var i = this.packages.length - 1; 0 <= i; --i ){
        if( this.packages[i].isWrapper() ){
            // clean up the wrappers
            if( this.packages[i].zoominListener ){
                GEvent.removeListener( this.packages[i].zoominListener );
            }
            if( this.packages[i].gpolygon ){
                this.map.removeOverlay( this.packages[i].gpolygon );
            }
            if( this.packages[i].gmarker ){
                this.map.removeOverlay( this.packages[i].gmarker  );
            }
            this.packages.splice(i,1);
        }else{
            // reset flag
            this.packages[i]._as_show = true;
            // clear caches
            this.packages[i]._gbounds = null;
            this.packages[i]._glatlngbounds = null;
        }
    }
    //-- convergence
    var t2 = (new Date()).getTime();
    var t3 = t2;
    var cnt = 0;
    var skips = 0;
    if( this.map.getZoom() < this.maxZoom ){
        var alone = [];
        var origins = this.packages.length;
        for( var i = 0; i < this.packages.length; ++i ){
            if( alone[i] || ! this.packages[i]._as_show ){
                continue;
            }
            alone[i] = true;
            for( var j = i + 1; j < this.packages.length; ++j ){
                if( alone[j] || ! this.packages[j]._as_show ){
                    continue;
                }
                var key = ''+ i +'-'+ j;
                if( onZoomInOrRefresh && ! isNaN(this.zoomExpand[key]) && this.zoomExpand[key] < currentZoom ){
                    ++skips;
                    continue;
                }
                ++cnt;
                var intersection_center_glatlng = this.getIntersectionCenterGLatLng(this.packages[i],this.packages[j]);
                if( intersection_center_glatlng ){
                    var wrapper = this.addMarker( intersection_center_glatlng );
                    wrapper._as_show = true;
                    wrapper.intersects = [this.packages[i],this.packages[j]];
                    this.packages[i]._as_show = false;
                    this.packages[j]._as_show = false;
                    alone[i] = false;
                    break;
                }else{
                    if( isNaN(this.zoomExpand[key]) || currentZoom < this.zoomExpand[key] ){
                        this.zoomExpand[key] = currentZoom;
                    }
                }
            }
        }
        //-- create the wrapper markers
        t3 = (new Date()).getTime();
        var markerOption = {"icon":this.wrapperIcon,"draggable":false};
        var hdlr_zoomin = function ( pkg ){
            MarkerReducer.Logger.write('- click zoom, pkg has intersects: '+ pkg.intersects.length);
            this.fitMapContainsAllIntersects(pkg.intersects[0],pkg.intersects[1]);
        };
        for( var i = origins; i < this.packages.length; ++i ){
            if( this.packages[i]._as_show ){
                var closure = GEvent.callbackArgs( this, hdlr_zoomin, this.packages[i] );
                this.packages[i].gmarker = new GMarker( this.packages[i].gmarker, markerOption );
                this.packages[i].zoominListener = GEvent.bind( this.packages[i].gmarker, 'click', this.map, closure );
            }
        }
    }
    //-- split times
    var t4 = (new Date()).getTime();
    MarkerReducer.Logger.write('- reset cnt: '+ cnt);
    MarkerReducer.Logger.write('- reset skips: '+ skips);
    MarkerReducer.Logger.write('- reset t2-t1: '+ (t2 - t1) +' ms');
    MarkerReducer.Logger.write('- reset t3-t2: '+ (t3 - t2) +' ms');
    MarkerReducer.Logger.write('- reset t4-t3: '+ (t4 - t3) +' ms');
    //-- show/hide GMarker(s)
    setTimeout( GEvent.callback( this, function(){
        var t5 = (new Date()).getTime();
        for( var i = this.packages.length - 1; 0 <= i ; --i ){
            if( this.packages[i]._as_show ){
                if( ! this.packages[i].gmarker._overlaied ){
                    this.map.addOverlay(this.packages[i].gmarker);
                }
                this.packages[i].gmarker.show();
            }else{
                this.packages[i].gmarker.hide();
            }
        }
        var t6 = (new Date()).getTime();
        MarkerReducer.Logger.write('- reset t6-t5: '+ (t6 - t5) +' ms');
    } ), 1 );
}
MarkerReducer.prototype.clearFields = function (){
    for( var i = 0; i < this.packages.length; ++i ){
        if( this.packages[i].gpolygon instanceof GPolygon ){
            this.map.removeOverlay( this.packages[i].gpolygon );
        }
    }
}
MarkerReducer.prototype.drawFields = function (){
    for( var i = 0; i < this.packages.length; ++i ){
        if( this.packages[i].gmarker instanceof GMarker && ! this.packages[i].gmarker.isHidden() ){
            // create GPolygon
            if( this.packages[i].isWrapper() ){
                if( this.wrapperFieldOptions instanceof Object ){
                    var glatlngbounds = this.packages[i]._glatlngbounds
                                      ? this.packages[i]._glatlngbounds
                                      : this.getGLatLngBoundsOfMarkerField(this.packages[i]);
                    for( var c = 0; c < this.packages[i].intersects.length; ++c ){
                        var extbounds = this.packages[i].intersects[c]._glatlngbounds
                                      ? this.packages[i].intersects[c]._glatlngbounds
                                      : this.getGLatLngBoundsOfMarkerField(this.packages[i].intersects[c]);
                        glatlngbounds.extend( extbounds.getSouthWest() );
                        glatlngbounds.extend( extbounds.getNorthEast() );
                    }
                    this.packages[i].gpolygon = MarkerReducer.GPolygonFromGLatLngBounds(
                        glatlngbounds,
                        this.wrapperFieldOptions.strokeColor,
                        this.wrapperFieldOptions.strokeWeight,
                        this.wrapperFieldOptions.strokeOpacity,
                        this.wrapperFieldOptions.fillColor,
                        this.wrapperFieldOptions.fillOpacity
                    );
                    this.map.addOverlay( this.packages[i].gpolygon );
                }
            }else{
                if( this.packageFieldOptions instanceof Object ){
                    this.packages[i].gpolygon = MarkerReducer.GPolygonFromGLatLngBounds(
                        ( this.packages[i]._glatlngbounds
                        ? this.packages[i]._glatlngbounds
                        : this.getGLatLngBoundsOfMarkerField(this.packages[i])
                        ),
                        this.packageFieldOptions.strokeColor,
                        this.packageFieldOptions.strokeWeight,
                        this.packageFieldOptions.strokeOpacity,
                        this.packageFieldOptions.fillColor,
                        this.packageFieldOptions.fillOpacity
                    );
                    this.map.addOverlay( this.packages[i].gpolygon );
                }
            }
        }
    }
}
/***************************************
    Class MarkerReducer.Package
*/
MarkerReducer.Package = function (/*GMarker or GLatLng*/gmarker,/*Object*/opts){
    opts = opts || {};
    this.gmarker = gmarker; // Original GMarker or GLatLng that is a seed of GMarker for warpper
    this.intersects = [];   // Array of MarkerReducer.Package. Two references of package chidren
    this.zoominListener;    // GEventListener ... cache for remove event listener
    this.gpolygon;          // GPolygon ... cache for remove overlay
    this.minZoom = opts.minZoom // to do
    this.maxZoom = opts.maxZoom // to do
}
MarkerReducer.Package.prototype.isWrapper = function (){
    return 0 < this.intersects.length ? true : false;
}
