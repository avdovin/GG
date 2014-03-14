// jQuery Swiper
// Author: Nikita K., nikita.ak.85@gmail.com
// Version: 0.1, 08.10.2013

(function (factory) {
    if (typeof define === 'function' && define.amd && define.amd.jQuery) {
        // AMD. Register as anonymous module.
        define(['jquery'], factory);
    } else {
        // Browser globals.
        factory(jQuery);
    }
}(function ($) {
    "use strict";

    //Constants
    var LEFT = "left",
        RIGHT = "right",
        UP = "up",
        DOWN = "down",
        IN = "in",
        OUT = "out",

        NONE = "none",
        AUTO = "auto",

        SWIPE = "swipe",
        PINCH = "pinch",
        TAP = "tap",
        DOUBLE_TAP = "doubletap",
        LONG_TAP = "longtap",

        HORIZONTAL = "horizontal",
        VERTICAL = "vertical",

        ALL_FINGERS = "all",

        DOUBLE_TAP_THRESHOLD = 10,

        PHASE_START = "start",
        PHASE_MOVE = "move",
        PHASE_END = "end",
        PHASE_CANCEL = "cancel",

        SUPPORTS_TOUCH = 'ontouchstart' in window,

        PLUGIN_NS = 'Swiper';

    var defaults = {
        fingers: 1,
        threshold: 75,
        cancelThreshold:null,
        pinchThreshold:20,
        maxTimeThreshold: null,
        fingerReleaseThreshold:250,
        longTapThreshold:500,
        doubleTapThreshold:200,
        swipe: null,
        swipeLeft: null,
        swipeRight: null,
        swipeUp: null,
        swipeDown: null,
        swipeStatus: null,
        pinchIn:null,
        pinchOut:null,
        pinchStatus:null,
        click:null, //Deprecated since 1.6.2
        tap:null,
        doubleTap:null,
        longTap:null,
        triggerOnTouchEnd: true,
        triggerOnTouchLeave:false,
        allowPageScroll: "auto",
        fallbackToMouseEvents: true
    };

    $.fn.swiper = function (method) {
        var $this = $(this),
            plugin = $this.data(PLUGIN_NS);

        //Check if we are already instantiated and trying to execute a method
        if (plugin && typeof method === 'string') {
            if (plugin[method]) {
                return plugin[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else {
                $.error('Method ' + method + ' does not exist on jQuery.swiper');
            }
        }
        //Else not instantiated and trying to pass init object (or nothing)
        else if (!plugin && (typeof method === 'object' || !method)) {
            return init.apply(this, arguments);
        }

        return $this;
    };

    //Expose our defaults so a user could override the plugin defaults
    $.fn.swiper.defaults = defaults;

    $.fn.swiper.phases = {
        PHASE_START: PHASE_START,
        PHASE_MOVE: PHASE_MOVE,
        PHASE_END: PHASE_END,
        PHASE_CANCEL: PHASE_CANCEL
    };

    $.fn.swiper.directions = {
        LEFT: LEFT,
        RIGHT: RIGHT,
        UP: UP,
        DOWN: DOWN,
        IN : IN,
        OUT: OUT
    };

    $.fn.swiper.pageScroll = {
        NONE: NONE,
        HORIZONTAL: HORIZONTAL,
        VERTICAL: VERTICAL,
        AUTO: AUTO
    };

    $.fn.swiper.fingers = {
        ONE: 1,
        TWO: 2,
        THREE: 3,
        ALL: ALL_FINGERS
    };

    function init(options) {
        //Prep and extend the options
        if (options && (options.allowPageScroll === undefined && (options.swipe !== undefined || options.swipeStatus !== undefined))) {
            options.allowPageScroll = NONE;
        }

        if (!options) {
            options = {};
        }

        //Check for deprecated options
        //Ensure that any old click handlers are assigned to the new tap, unless we have a tap
        if(options.click!==undefined && options.tap===undefined) {
            options.tap = options.click;
        }

        //pass empty object so we dont modify the defaults
        options = $.extend({}, $.fn.swiper.defaults, options);

        //For each element instantiate the plugin
        return this.each(function () {
            var $this = $(this);

            //Check we havent already initialised the plugin
            var plugin = $this.data(PLUGIN_NS);

            if (!plugin) {
                plugin = new TouchSwipe(this, options);
                $this.data(PLUGIN_NS, plugin);
            }
        });
    }

    function TouchSwipe(element, options) {
        var useTouchEvents = (SUPPORTS_TOUCH || !options.fallbackToMouseEvents),
            START_EV = useTouchEvents ? 'touchstart' : 'mousedown',
            MOVE_EV = useTouchEvents ? 'touchmove' : 'mousemove',
            END_EV = useTouchEvents ? 'touchend' : 'mouseup',
            LEAVE_EV = useTouchEvents ? null : 'mouseleave', //we manually detect leave on touch devices, so null event here
            CANCEL_EV = 'touchcancel';

        //touch properties
        var distance = 0,
            direction = null,
            duration = 0,
            startTouchesDistance = 0,
            endTouchesDistance = 0,
            pinchZoom = 1,
            pinchDistance = 0,
            pinchDirection = 0,
            maximumsMap=null;



        //jQuery wrapped element for this instance
        var $element = $(element);

        //Current phase of th touch cycle
        var phase = "start";

        // the current number of fingers being used.
        var fingerCount = 0;

        //track mouse points / delta
        var fingerData=null;

        //track times
        var startTime = 0,
            endTime = 0,
            previousTouchEndTime=0,
            previousTouchFingerCount=0,
            doubleTapStartTime=0;

        //Timeouts
        var singleTapTimeout=null;

        // Add gestures to all swipable areas if supported
        try {
            $element.bind(START_EV, touchStart);
            $element.bind(CANCEL_EV, touchCancel);
        }
        catch (e) {
            $.error('events not supported ' + START_EV + ',' + CANCEL_EV + ' on jQuery.swipe');
        }

        this.enable = function () {
            $element.bind(START_EV, touchStart);
            $element.bind(CANCEL_EV, touchCancel);
            return $element;
        };

        this.disable = function () {
//            removeListeners();
            return $element;
        };

        this.destroy = function () {
//            removeListeners();
            $element.data(PLUGIN_NS, null);
            return $element;
        };

        function touchStart(jqEvent) {
            if (getTouchInProgress())
                return;

            //Check if this element matches any in the excluded elements selectors,  or its parent is excluded, if so, DON'T swipe
            if ($(jqEvent.target).closest( options.excludedElements, $element ).length>0)
                return;

            //As we use Jquery bind for events, we need to target the original event object
            //If these events are being programmatically triggered, we don't have an original event object, so use the Jq one.
            var event = jqEvent.originalEvent ? jqEvent.originalEvent : jqEvent;

            var ret,
                evt = SUPPORTS_TOUCH ? event.touches[0] : event;

            phase = PHASE_START;

            //If we support touches, get the finger count
            if (SUPPORTS_TOUCH) {
                // get the total number of fingers touching the screen
                fingerCount = event.touches.length;
            }
            //Else this is the desktop, so stop the browser from dragging the image
            else {
                jqEvent.preventDefault(); //call this on jq event so we are cross browser
            }

            //clear vars..
            distance = 0;
            direction = null;
            pinchDirection=null;
            duration = 0;
            startTouchesDistance=0;
            endTouchesDistance=0;
            pinchZoom = 1;
            pinchDistance = 0;
            fingerData=createAllFingerData();

            createFingerData( 0, evt );
            startTime = getTimeStamp();

            setTouchInProgress(true);

            var currentFinger = updateFingerData(evt);

            if (options.swipe) {
                ret = options.swipe.call($element, event, phase, direction || null, distance || 0, duration || 0, currentFinger);
                //If the status cancels, then dont run the subsequent event handlers..
                if(ret===false) return false;
            }

            return null;
        }

        function touchMove(jqEvent) {
            if (!getTouchInProgress())
                return;

            var event = jqEvent.originalEvent ? jqEvent.originalEvent : jqEvent;

            if (phase === PHASE_END || phase === PHASE_CANCEL)
                return;

            var ret,
                evt = SUPPORTS_TOUCH ? event.touches[0] : event;

            var currentFinger = updateFingerData(evt);
            endTime = getTimeStamp();

            phase = PHASE_MOVE;

            direction = calculateDirection(currentFinger.start, currentFinger.end);

            //Distance and duration are all off the main finger
            distance = calculateDistance(currentFinger.start, currentFinger.end);
            duration = calculateDuration();

            if (options.swipe) {
                ret = options.swipe.call($element, event, phase, direction || null, distance || 0, duration || 0, currentFinger);
                //If the status cancels, then dont run the subsequent event handlers..
                if(ret===false) return false;
            }
        }

        function touchEnd(jqEvent) {
            var event = jqEvent.originalEvent;

            var ret,
                evt = SUPPORTS_TOUCH ? event.touches[0] : event;

            jqEvent.preventDefault();

            //Set end of swipe
            endTime = getTimeStamp();

            //Get duration incase move was never fired
            duration = calculateDuration();

            phase = PHASE_END;

            var currentFinger = updateFingerData(evt);

            if (options.swipe) {
                ret = options.swipe.call($element, event, phase, direction || null, distance || 0, duration || 0, currentFinger);
                //If the status cancels, then dont run the subsequent event handlers..
                if(ret===false) return false;
            }

            touchCancel();

            return null;
        }

        function touchCancel() {
            fingerCount = 0;
            endTime = 0;
            startTime = 0;
            startTouchesDistance=0;
            endTouchesDistance=0;
            pinchZoom=1;

            setTouchInProgress(false);
        }

        function touchLeave(jqEvent) {
            var event = jqEvent.originalEvent;
            touchEnd(jqEvent);
        }

        function getTouchInProgress() {
            return !!($element.data(PLUGIN_NS+'_intouch') === true);
        }

        function setTouchInProgress(val) {

            //Add or remove event listeners depending on touch status
            if(val===true) {
                $element.bind(MOVE_EV, touchMove);
                $element.bind(END_EV, touchEnd);

                //we only have leave events on desktop, we manually calcuate leave on touch as its not supported in webkit
                if(LEAVE_EV) {
                    $element.bind(LEAVE_EV, touchLeave);
                }
            } else {
                $element.unbind(MOVE_EV, touchMove, false);
                $element.unbind(END_EV, touchEnd, false);

                //we only have leave events on desktop, we manually calcuate leave on touch as its not supported in webkit
                if(LEAVE_EV) {
                    $element.unbind(LEAVE_EV, touchLeave, false);
                }
            }


            //strict equality to ensure only true and false can update the value
            $element.data(PLUGIN_NS+'_intouch', val === true);
        }

        function createFingerData( index, evt ) {
            var id = evt.identifier!==undefined ? evt.identifier : 0;

            fingerData[index].identifier = id;
            fingerData[index].start.x = fingerData[index].end.x = evt.pageX||evt.clientX;
            fingerData[index].start.y = fingerData[index].end.y = evt.pageY||evt.clientY;

            return fingerData[index];
        }

        function updateFingerData(evt) {

            if (typeof evt == 'undefined') return false;

            var id = evt.identifier!==undefined ? evt.identifier : 0;
            var f = getFingerData( id );

            f.end.x = evt.pageX||evt.clientX;
            f.end.y = evt.pageY||evt.clientY;

            return f;
        }

        function getFingerData( id ) {
            for(var i=0; i<fingerData.length; i++) {
                if(fingerData[i].identifier == id) {
                    return fingerData[i];
                }
            }
        }

        function createAllFingerData() {
            var fingerData=[];
            for (var i=0; i<=5; i++) {
                fingerData.push({
                    start:{ x: 0, y: 0 },
                    end:{ x: 0, y: 0 },
                    identifier:0
                });
            }

            return fingerData;
        }

        function calculateDuration() {
            return endTime - startTime;
        }

        function calculateDistance(startPoint, endPoint) {
            return Math.round(Math.sqrt(Math.pow(endPoint.x - startPoint.x, 2) + Math.pow(endPoint.y - startPoint.y, 2)));
        }

        function calculateAngle(startPoint, endPoint) {
            var x = startPoint.x - endPoint.x;
            var y = endPoint.y - startPoint.y;
            var r = Math.atan2(y, x); //radians
            var angle = Math.round(r * 180 / Math.PI); //degrees

            //ensure value is positive
            if (angle < 0) {
                angle = 360 - Math.abs(angle);
            }

            return angle;
        }

        function calculateDirection(startPoint, endPoint ) {
            var angle = calculateAngle(startPoint, endPoint);

            if ((angle <= 45) && (angle >= 0)) {
                return LEFT;
            } else if ((angle <= 360) && (angle >= 315)) {
                return LEFT;
            } else if ((angle >= 135) && (angle <= 225)) {
                return RIGHT;
            } else if ((angle > 45) && (angle < 135)) {
                return DOWN;
            } else {
                return UP;
            }
        }

        function getTimeStamp() {
            var now = new Date();
            return now.getTime();
        }

        function getbounds( el ) {
            el = $(el);
            var offset = el.offset();

            var bounds = {
                left:offset.left,
                right:offset.left+el.outerWidth(),
                top:offset.top,
                bottom:offset.top+el.outerHeight()
            }

            return bounds;
        }

        function isInBounds(point, bounds) {
            return (point.x > bounds.left && point.x < bounds.right && point.y > bounds.top && point.y < bounds.bottom);
        };

    }

}));