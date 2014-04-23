// jQuery Slideshow/Carousel
// Author: Nikita K., nikita.ak.85@gmail.com
// Version: 2.11, 03.04.2014

(function($){

	$.galleryCarousel = {version: '2.1'};

	var methods = {
		init: function(params){

			var defaults = {
				autostart: true,		// auto start carousel
				autoloop: true,		 // auto loop after action (if autostart == false)
				controls: true,		 // show next/prev controls
				dots: false,			// show "dots" list for each slide
				throughdots: false,	 // click through dots container (if it transparent for ex.)
				autostop: false,		// autostop sliding on mouseover
				effect: 'fade',		 // effects: fade, slide
				fade: 1000,			 // ms, fadeIn/Out time
				interval: 5000,		 // ms, interval between switch
				resize: false,		  // if gallery is resizable (window resize)
				callback: function(){}, // callback after slide
				cb: {				   // callbacks (new version)
					before: function(){},
					after: function(){}
				},
				group: null			 // if gallery aligned to another gallery (maybe popup)
			};
			var options = $.extend(defaults, params);

			return this.each(function(){

				var $this = $(this),
					$thisid = $this.attr("id"),
					$data = $this.data('galleryCarousel');

				if (!$thisid) { // create random id
					$this.attr("id", "gc" + (new Date()).getTime());
					$thisid = $this.attr("id");
				}

				if (!$data) {
					$this.data('galleryCarousel', options).addClass('galleryCarousel');
					$data = options;
				}

				$this.html('<div id="'+$thisid+'-wrapper" class="galleryCarousel-wrapper">'+$this.html()+'</div>');

				var $wrapper   = $this.find(".galleryCarousel-wrapper"),
					$objects   = $wrapper.find("> *");
				   
				$data.type = $objects.is("img") ? "img" : "div";

				if ($objects.length < 1) return false; // do nothing if no objects

				$data.slides = $objects.length;
				$data.slide = 1;

				if ($data.resize) {
					if ($data.type == 'img') {
						$this.css("height", $("img:visible", $this).height());
						$(window).bind('resize.galleryCarousel', methods.resize);
					}
				}

				// generate code if blocks are 'img'
				if ($data.type == 'img') {
					$objects.each(function(i){
						$(this).wrap(function(){
							//var href = $(this).data("href") ? 'href="'+$(this).data("href")+'"' : 'href="#"';
							var href = $(this).data("href") ? 'href="'+$(this).data("href")+'"' : '';
							var target = $(this).data("target") ? 'target="'+$(this).data("target")+'"' : '';
							return '<div data-slide="'+(i+1)+'" class="galleryCarousel-slide" id="'+$thisid+'-slide-'+(i+1)+'" style="z-index: '+($objects.length-i)+';'+(i>0?' display: none':'')+'"><'+(href ? 'a' : 'span')+' '+href+' '+target+' title="'+$(this).attr("alt")+'"></a></div>';
						});
					});

					// img load status (used below)
					$objects.load(function(){
						$(this).data("loaded", 1);
					});

				// generate code if blocks are 'div'
				} else if ($data.type == 'div') {
					$objects.each(function(i){
						$(this)
							.addClass("galleryCarousel-slide")
							.attr("id", $thisid+'-slide-'+(i+1))
							.css("z-index", ($objects.length-i))
							.data("slide", (i+1));
					});
				}

				if ($objects.length == 1) return false; // no switch if number if images <= 1

				if ($data.type == 'img') $objects = $this.find(".galleryCarousel-slide");

				$data.slideWidth = $objects.width();

				if ($data.controls) {
					$("<a/>", {id: $thisid+'-prev', 'class': 'galleryCarousel-nav galleryCarousel-prev', href: '#'}).appendTo($this);
					$("<a/>", {id: $thisid+'-next', 'class': 'galleryCarousel-nav galleryCarousel-next', href: '#'}).appendTo($this);
					$("#"+$thisid+"-prev, #"+$thisid+"-next", $this).click(function(){methods.changeSlide.call(this, $this); return false;});
				}

				if ($data.dots) {
					$("<div/>", {id: $thisid+'-dots', 'class': 'galleryCarousel-dots'}).appendTo($this);
					var $dots = $("#"+$thisid+'-dots');
					$objects.each(function(i){
						$("<a/>", {id: $thisid+'-dot-'+(i+1), 'class': 'galleryCarousel-dot'+(i==0?' current':''), 'data-slide': (i+1), href: '#'}).appendTo($dots);
					});
				}

				if (jQuery.fn.swiper && $data.effect == "slide") {

					// some magic
					$objects.on("mousedown touchstart", "a", function(e){

						console.log('asd');

						// sliding now flag
						$data.sliding = 1;

						// if sliding now and switching object is right now
						if ($data.sliding && $data.switching) {
							$data.swipe = 0; // disable swipe
						} else {
							$data.swipe = 1; // enable swipe
						}

						$this.data('galleryCarousel', $data);

						$objects.css("z-index", 0).css("display", "");
						$("#"+$thisid+"-slide-"+$data.slide).css("z-index", 100);

						// temporary remove HREF to prevent moving to url
						$(this).data("href", $(this).attr("href")).removeAttr("href");

					}).on("mouseout", "a", function(e){
						// when swiping with mouse and mouseout event triggered do some magic to prevent bugs
						if ($data.sliding) {
							$(this).trigger("mouseup");
							// timer must be
							setTimeout(function(){$data.sliding = 0; $this.data('galleryCarousel', $data);}, 50);
						}
					});

					$this.swiper({
						swipe: function(event, phase, direction, distance, duration, finger){
							if (phase == "start") {

							} else if (phase == "move") {
								var duration=0;
								if (finger.end.x - finger.start.x > 0) {
									scrollBlock(parseInt($wrapper.css("left"),10)||0-distance, duration);
								} else {
									scrollBlock(parseInt($wrapper.css("left"),10)||0+distance, duration);
								}
							} else if (phase == "end") {
								scrollBlock(0, 500);
							}
						}
					});

					function scrollBlock(distance, duration) {

						$wrapper.css("-webkit-transition-duration", (duration/1000).toFixed(1) + "s");

						//inverse the number we set in the css
						var value = (distance<0 ? "" : "-") + Math.abs(distance).toString();

						$wrapper.css("-webkit-transform", "translate3d("+value +"px,0px,0px)");
					}

				}

				if (jQuery.fn.swipe && $data.effect == "slide") {

					// some magic
					$objects.on("mousedown touchstart", "a", function(e){

						// sliding now flag
						$data.sliding = 1;

						// if sliding now and switching object is right now
						if ($data.sliding && $data.switching) {
							$data.swipe = 0; // disable swipe
						} else {
							$data.swipe = 1; // enable swipe
						}

						$this.data('galleryCarousel', $data);

						$objects.css("z-index", 0).css("display", "");
						$("#"+$thisid+"-slide-"+$data.slide).css("z-index", 100);

						// temporary remove HREF to prevent moving to url
						$(this).data("href", $(this).attr("href")).removeAttr("href");

					}).on("mouseout", "a", function(e){
						// when swiping with mouse and mouseout event triggered do some magic to prevent bugs
						if ($data.sliding) {
							$(this).trigger("mouseup");
							// timer must be
							setTimeout(function(){$data.sliding = 0; $this.data('galleryCarousel', $data);}, 50);
						}
					});

					function swipeStatus(event, phase, direction, distance, fingers) {

						if (!$data.swipe) return false;

						var duration = 0;

						//If we are moving before swipe, and we are going L or R, then manually drag the images
						if (phase == "move" && (direction == "left" || direction == "right")) {

							if (direction == "left") {
								scrollEntry(-distance, duration);
							} else {
								scrollEntry(distance, duration);
							}

						} else if ((phase == "cancel" || phase == "end") && (direction == "left" || direction == "right")) {

							if (phase == "cancel") { // Else, cancel means snap back to the begining
								scrollEntry(0, duration);
							} else { // Else end means the swipe was completed, so move to the next image
								if (direction == "left") {
									scrollEntry(-distance, duration, true);
								} else if (direction == "right") {
									scrollEntry(distance, duration, true);
								} else {
									scrollEntry(50, duration, true);
								}
							}

							// start carousel start timer after switch
							var interval = function() {
								if ($data.autoloop) methods.setInterval.call($this);
							}
							setTimeout(interval, $data.fade);

							// back HREF to its default value
							$objects.find("a").each(function(){
								if ($(this).data("href")) {
									var $link = $(this);
									if (distance <= 10) {
										$link.attr("href", $link.data("href")).removeData("href");

										if ($data.isMobile) {
											var el = $link.get(0);
											var evt = document.createEvent("MouseEvents");
											evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
											el.dispatchEvent(evt);
										}

									} else {
										setTimeout(function(){$link.attr("href", $link.data("href")).removeData("href")}, 10);
									}
								}
							});

						} else if ((phase == "cancel" || phase == "end") && (direction == "up" || direction == "down")) {

							scrollEntry(50, duration, true);

						}
					}

					function scrollEntry(distance, duration, ended) {
						var nextSlide	 = parseInt($data.slide)+1;
							nextSlide	 = nextSlide > $data.slides ? 1 : nextSlide;

						var prevSlide	 = parseInt($data.slide)-1;
							prevSlide	 = prevSlide == 0 ? $data.slides : prevSlide;

						var $currentSlide = $("#"+$thisid+"-slide-"+$data.slide),
							$nextSlide	= $("#"+$thisid+"-slide-"+nextSlide),
							$prevSlide	= $("#"+$thisid+"-slide-"+prevSlide);

						if (!ended) { // dragging

							if (distance > 0 && distance < $data.slideWidth) {
								$currentSlide.css("left", 0+distance);
								$prevSlide.css("z-index", 100).css("left", -$data.slideWidth+distance);

								// if slides more than 2, show third slide
								if ($data.slides > 2) {
									$nextSlide.css("z-index", 100).css("left", $data.slideWidth+distance);
								}
							} else if (distance < 0 && distance > -$data.slideWidth) {
								$currentSlide.css("left", 0+distance);
								$nextSlide.css("z-index", 100).css("left", $data.slideWidth+distance);

								// if slides more than 2, show third slide
								if ($data.slides > 2) {
									$prevSlide.css("z-index", 100).css("left", -$data.slideWidth+distance);
								}
							}

						} else if (ended && distance > -$data.slideWidth/4 && distance < $data.slideWidth/4) { // return if distance is low

							if (distance > 0) {
								$currentSlide.css("z-index", 101).animate({"left": 0});
								$prevSlide.css("z-index", 100).animate({"left": -$data.slideWidth});

								// if slides more than 2, show third slide
								if ($data.slides > 2) {
									$nextSlide.css("z-index", 100).animate({"left": $data.slideWidth});
								}
							} else {
								$currentSlide.animate({"left": 0});
								$nextSlide.css("z-index", 100).animate({"left": $data.slideWidth});

								// if slides more than 2, show third slide
								if ($data.slides > 2) {
									$prevSlide.css("z-index", 100).animate({"left": -$data.slideWidth});
								}
							}

						} else if (ended && (distance < -$data.slideWidth/4 || distance > $data.slideWidth/4)) { // if ok

							if (distance > 0) {
								$currentSlide.animate({"left": parseInt($currentSlide.css("left"), 10)+200});
								$prevSlide.css("z-index", 100).animate({"left": parseInt($prevSlide.css("left"), 10)+200});

								// if slides more than 2, show third slide
								if ($data.slides > 2) {
									$nextSlide.css("z-index", 100).animate({"left": parseInt($nextSlide.css("left"), 10)+200});
								}
							} else {
								$currentSlide.animate({"left": parseInt($currentSlide.css("left"), 10)-200});
								$nextSlide.css("z-index", 100).animate({"left": parseInt($nextSlide.css("left"), 10)-200});

								// if slides more than 2, show third slide
								if ($data.slides > 2) {
									$prevSlide.css("z-index", 100).animate({"left": parseInt($prevSlide.css("left"), 10)-200});
								}
							}

						}

						// start carousel start timer after slide
						var interval = function() {
							if ($data.autoloop) methods.setInterval.call($this);
						}
						setTimeout(interval, $data.fade);

					}

					$wrapper.swipe({
						// allowPageScroll: "vertical",
						excludedElements: "",
						swipeLeft: function(event, direction, distance, duration, fingerCount){
							if (-distance >= -$data.slideWidth/4) return false; // if distance is low

							setTimeout(function(){$("#"+$thisid+"-next").click()}, 1);
						},
						swipeRight: function(event, direction, distance, duration, fingerCount){
							if (distance <= $data.slideWidth/4) return false; // if distance is low

							setTimeout(function(){$("#"+$thisid+"-prev").click()}, 1);
						},
						swipeStatus : swipeStatus
					});

				}

				$("#"+$thisid+'-dots a').click(function(e){
					e.stopPropagation();

					var $gallery = $("#"+$thisid),
						$data = $gallery.data('galleryCarousel');

					if ($data.switching || $data.slide == parseInt($(this).data("slide"))) return false;
					$data.switching = 1;

					methods.setSlide.call($this, parseInt($(this).data("slide")), $data.slide);
					return false;
				});

				if ($data.throughdots) {
					$("#"+$thisid+"-dots").click(function(){
						var $gallery = $("#"+$thisid),
							$data = $gallery.data('galleryCarousel');
						$("#"+$thisid+"-slide-"+$data.slide)[0].click();
					});
				}

				// isMobile
				$data.isMobile = typeof isMobile == 'undefined' ? false : isMobile.any() ? true : false;

				// set hovered state to block autosliding, but not block controls
				if ($data.autostop && !$data.isMobile) {
					$this.hover(
						function(){ $data.mouseover = 1; },
						function(){ $data.mouseover = 0; }
					);
				}

				$this.data('galleryCarousel', $data);			  

				// Start
				if ($data.autostart) methods.setInterval.call($this); // start carousel after init

			});

		},
		changeSlide: function(){
			var $gallery = arguments[0],
				$galid = $gallery.attr("id"),
				$data = $gallery.data('galleryCarousel');

			if ($data.switching || ($data.mouseover && !$(this).is(".galleryCarousel-nav"))) return false;
			$data.switching = 1;

			var currentSlide = $data.slide,
				direction	= $(this).is("#"+$galid+"-prev") ? -1 : 1,
				nextSlide = direction < 0 ? currentSlide - 1 : currentSlide + 1,
				nextSlide = nextSlide < 1 ? $data.slides : nextSlide > $data.slides ? 1 : nextSlide;

			// if image not loaded - do nothing
			if ($data.type == 'img' && !$("#"+$galid+"-slide-"+nextSlide).find("img").data("loaded")) return false;

			$data.slide = nextSlide;
			$gallery.data('galleryCarousel', $data);

			methods.setSlide.call($gallery, nextSlide, currentSlide, direction);
		},
		setSlide: function(){
			var $gallery	 = this,
				$galid	   = $gallery.attr("id"),
				$data		= $gallery.data('galleryCarousel'),
				$wrapper	 = $("#"+$galid+"-wrapper"),
				nextSlide	= arguments[0],
				currentSlide = arguments[1],
				direction	= arguments[2];

			$data.slide = nextSlide;
			$gallery.data('galleryCarousel', $data);

			// switch to same slide of linked gallery
			if ($data.group) {
				$(".galleryCarousel").not($gallery).each(function(){
					var data = $(this).data('galleryCarousel');
					if ($data.slide != data.slide) {
						$(this).galleryCarousel('setSlide', $data.slide);
					}
				});
			}

			var $gallery_dots	= $gallery.find("#"+$galid+"-dots"),
				$gallery_slides  = $wrapper.find(".galleryCarousel-slide"),
				$gallery_current = $gallery.find("#"+$galid+"-slide-"+currentSlide),
				$gallery_toggle  = $wrapper.find("#"+$galid+"-slide-"+nextSlide);

			if ($data.effect == 'fade') {

				$gallery_slides.css("z-index", 0);
				$gallery_dots.find(".galleryCarousel-dot").removeClass("current");
				$gallery_toggle.hide().css("z-index", 100).fadeIn($data.fade, function(){
					$("#"+$galid+"-dot-"+nextSlide).addClass("current");
					$gallery_slides.not(this).hide();
					$data.switching = 0;

					$gallery.data('galleryCarousel', $data);

					if (typeof $data.cb.after != 'undefined') $data.cb.after(currentSlide, nextSlide);
				});

				$data.callback(currentSlide, nextSlide);

				if (typeof $data.cb.before != 'undefined') $data.cb.before(currentSlide, nextSlide);

			} else if ($data.effect == 'slide') {

				$gallery_slides.css("z-index", 0).css("display", "");
				$gallery_current.css("z-index", 100);
				$gallery_toggle.css("z-index", 100);
				$gallery_dots.find(".galleryCarousel-dot").removeClass("current");

				var velocity = 1;

				if (direction > 0 || (nextSlide > currentSlide && !direction)) {

					if (!$data.sliding || parseInt($gallery_toggle.css("left"),10)%$data.slideWidth == 0) {
						$gallery_toggle.css("left", $data.slideWidth);
					} else {
						$data.sliding = 0;

						velocity = Math.abs(parseInt($gallery_current.css("left"), 10));
						velocity = ($data.slideWidth-velocity)/$data.slideWidth;

						$gallery.data('galleryCarousel', $data);

					}

					$gallery_current.stop(false,false).animate({left: -$data.slideWidth}, $data.fade*velocity);
					$gallery_toggle.stop(false,false).animate({left: 0}, $data.fade*velocity, function(){
						$("#"+$galid+"-dot-"+nextSlide).addClass("current");
						$data.switching = 0;
						$data.swipe = 0;

						$gallery.data('galleryCarousel', $data);

						if (typeof $data.cb.after != 'undefined') $data.cb.after(currentSlide, nextSlide);
					});

					if (typeof $data.cb.before != 'undefined') $data.cb.before(currentSlide, nextSlide);

				} else if (direction < 0 || (nextSlide < currentSlide && !direction)) {

					if (!$data.sliding || parseInt($gallery_toggle.css("left"),10)%$data.slideWidth == 0) {
						$gallery_toggle.css("left", -$data.slideWidth);
					} else {
						$data.sliding = 0;

						velocity = Math.abs(parseInt($gallery_current.css("left"), 10));
						velocity = ($data.slideWidth-velocity)/$data.slideWidth;

						$gallery.data('galleryCarousel', $data);
					}

					$gallery_current.stop(false,false).animate({left: $data.slideWidth}, $data.fade*velocity);
					$gallery_toggle.stop(false,false).animate({left: 0}, $data.fade*velocity, function(){
						$("#"+$galid+"-dot-"+nextSlide).addClass("current");
						$data.switching = 0;
						$data.swipe = 0;

						$gallery.data('galleryCarousel', $data);

						if (typeof $data.cb.after != 'undefined') $data.cb.after(currentSlide, nextSlide);
					});

					if (typeof $data.cb.before != 'undefined') $data.cb.before(currentSlide, nextSlide);

				} else {

				}

			}

			// start carousel start timer after switch
			var interval = function() {
				if ($data.autoloop) methods.setInterval.call($gallery);
			}
			setTimeout(interval, $data.fade);
		},
		resize: function(){
			$(".galleryCarousel").each(function(){
				if ($(this).data('galleryCarousel').resize) {
					$(this).css("height", $(".galleryCarousel-slide:visible img", $(this)).height());
				}
			});
		},
		setInterval: function(){
			var $gallery = this,
				$galid = $gallery.attr("id"),
				$data = $gallery.data('galleryCarousel');

			if (typeof document.galleryIntervalCarousel == 'undefined') document.galleryIntervalCarousel = {};
			if (typeof document.galleryStartCarousel == 'undefined') document.galleryStartCarousel = {};

			if (typeof document.galleryIntervalCarousel[$galid] != 'undefined') clearInterval(document.galleryIntervalCarousel[$galid]);

			if (typeof document.galleryStartCarousel[$galid] == 'undefined') {
				document.galleryStartCarousel[$galid] = function() {
					$gallery.galleryCarousel("changeSlide", $gallery);
				}
			}

			document.galleryIntervalCarousel[$galid] = setInterval(document.galleryStartCarousel[$galid], $data.interval);
		},
		destroy: function(){
			return this.each(function(){
				$(window).unbind('.galleryCarousel');
			})
		}
	}

	$.fn.galleryCarousel = function( method ) {

		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.galleryCarousel' );
		}

	};

})(jQuery);