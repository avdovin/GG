var f = void 0,
    g = !0,
    h = null,
    k = !1,
    l = jQuery;
window.sa = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function (a) {
    window.setTimeout(a, 1E3 / 60)
};
var p = document.getElementsByTagName("script"),
    r = p[p.length - 1].src.slice(0, p[p.length - 1].src.lastIndexOf("/"));

function s(a) {
    return a;
}
function t(a) {
    for (var b = "", c, d = s("charCodeAt"), e = a[d](0) - 32, j = 1; j < a.length - 1; j++) c = a[d](j), c ^= e & 31, e++, b += String[s("fromCharCode")](c);
    a[d](j);
    return b
}
function u(a, b) {
    var c = b.uriEscapeMethod;
    return "escape" == c ? escape(a) : "encodeURI" == c ? encodeURI(a) : a
}
var v = window,
    x = g,
    y = k,
    z = "NOTAPP",
    B = "TRIAL".length,
    C = k,
    D = k;
5 == B ? D = g : 4 == B && (C = g);

function E(a, b) {
    function c() {
        "" != b.image ? d.C(b.image, b.zoomImage) : d.C("" + a.attr("src"), b.zoomImage)
    }
    var d = this;
    b = l.extend({}, l.fn.CloudZoom.defaults, b);
    var e = E.fa(a);
    b = l.extend({}, b, e);
    e = a.parent();
    e.is("a") && "" == b.zoomImage && (b.zoomImage = e.attr("href"), e.removeAttr("href"));
    e = l("<div class='" + b.zoomClass + "'</div>");
    l("body")
        .append(e);
    this.ca = e.width();
    this.ba = e.height();
    e.remove();
    this.options = b;
    this.a = a;
    this.g = this.f = this.c = this.d = 0;
    this.u = this.t = h;
    this.n = this.B = 0;
    this.ya = this.caption = "";
    this.ia = {
        x: 0,
        y: 0
    };
    this.k = [];
    this.b = this.r = this.q = h;
    this.J = "";
    this.O = this.X = this.N = k;
    this.h = h;
    this.id = ++E.id;
    this.w = this.ka = this.ja = 0;
    this.l = this.e = h;
    this.Z = 0;
    this.da(a);
    if (a.is(":hidden")) var j = setInterval(function () {
        a.is(":hidden") || (clearInterval(j), c())
    }, 100);
    else c()
}
E.id = 0;
E.prototype.na = function (a) {
    var b = this.J.replace(/^\/|\/$/g, "");
    if (0 == this.k.length) return {
        href: this.options.zoomImage,
        title: this.a.attr("title")
    };
    if (a != f) return this.k;
    a = [];
    for (var c = 0; c < this.k.length && this.k[c].href.replace(/^\/|\/$/g, "") != b; c++);
    for (b = 0; b < this.k.length; b++) a[b] = this.k[c], c++, c >= this.k.length && (c = 0);
    return a
};
E.prototype.getGalleryList = E.prototype.na;
E.prototype.F = function () {
    clearTimeout(this.Z);
    this.l != h && this.l.remove()
};
E.prototype.C = function (a, b) {
    var c = this;
    this.F();
    c.h != h && (c.h.remove(), c.h = h);
    this.r != h && (this.r.cancel(), this.r = h);
    this.q != h && (this.q.cancel(), this.q = h);
    c.Z = setTimeout(function () {
        c.l = l("<div class='cloudzoom-ajax-loader' style='position:absolute;left:0px;top:0px'/>");
        l("body")
            .append(c.l);
        var a = c.l.width(),
            b = c.l.height(),
            a = c.a.offset()
                .left + c.a.width() / 2 - a / 2,
            b = c.a.offset()
                .top + c.a.height() / 2 - b / 2;
        c.l.offset({
            left: a,
            top: b
        })
    }, 1E3);
    this.J = "" != b && b != f ? b : a;
    this.O = this.X = k;
    var d = l(new Image)
        .css({
        display: "none",
        position: "absolute"
    });
    l("body")
        .append(d);
    c.N && !("inside" == c.options.zoomPosition && c.e != h) && (c.h = l(new Image)
        .css({
        position: "absolute"
    }), c.h.attr("src", c.a.attr("src")), c.h.width(c.a.width()), c.h.height(c.a.height()), c.h.offset(c.a.offset()), l("body")
        .append(c.h));
    this.r = new F(d, this.J, function (a, b) {
        c.r = h;
        c.X = g;
        c.f = d.width();
        c.g = d.height();
        d.remove();
        b !== f ? (c.F(), c.options.errorCallback({
            $element: c.a,
            type: "IMAGE_NOT_FOUND",
            data: b.ea
        })) : c.ha()
    });
    this.q = new F(c.a, a, function (a, b) {
        c.q = h;
        c.O = g;
        c.h != h && c.h.fadeOut(c.options.fadeTime, function () {
            c.h = h;
            l(this)
                .remove()
        });
        b !== f ? (c.F(), c.options.errorCallback({
            $element: c.a,
            type: "IMAGE_NOT_FOUND",
            data: b.ea
        })) : c.ha()
    })
};
E.prototype.loadImage = E.prototype.C;
E.prototype.la = function () {
    alert("Cloud Zoom API OK")
};
E.prototype.apiTest = E.prototype.la;
E.prototype.p = function () {
    this.e != h && this.e.M();
    this.e = h
};
E.prototype.M = function () {
    l(document)
        .unbind("mousemove." + this.id);
    this.a.unbind();
    this.b != h && (this.b.unbind(), this.p());
    this.a.removeData("CloudZoom")
};
E.prototype.destroy = E.prototype.M;
E.prototype.$ = function () {
    var a = this;
    a.a.bind("mouseover", function (b) {
        if (a.b == h) {
            var c = a.a.offset();
            b = new E.D(b.pageX - c.left, b.pageY - c.top);
            a.P();
            a.A();
            a.o(b, 0);
            a.G();
            a.e.update()
        }
    })
};
E.prototype.ha = function () {
    var Image = this;
    var a = this;

    Image.X && 
    Image.O && 
    	(this.F(), 
    	 this.V(),
    	 Image.e != h && 
    	 (
    	 	Image.p(), 
    	 	Image.A(), 
    	 	Image.u.attr("src", u(this.Image.attr("src"), this.options)), 
    	 	Image.o(Image.ia, 0)
    	 ), 
    	 Image.N || 
    	(
    		Image.N = g,
    		l(document).bind("mousemove." + this.id, function (b, c) {
		        if (Image.b != h) {
		            c != f && (b = c);
		            var d = Image.b.offset(),
		                d = new E.D(b.pageX - Math.floor(d.left), b.pageY - Math.floor(d.top));

		            if (0 > d.x || d.x > Image.c || 0 > d.y || d.y > Image.d) {
		            	Image.b.remove();
		            	Image.p();
		            	Image.b = h;
		            } else {
		            	//here
		            	Image.o(d, 0); // change blank position
		            	Image.G(); // change zooming position
		            }

		        }
    		}),
    		a.$(), a.a.bind("touchmove touchend touchstart", function (b) {
	        var c = a.a.offset(),
	            d, e;
	        "touchend" != b.type && (e = b.originalEvent.touches[0], d = new E.D(e.pageX - c.left, e.pageY - c.top));
	        switch (b.type) {
	            case "touchend":
	                clearTimeout(a.interval);
	                a.b == h ? a.W() : (a.b.remove(), a.b = h, a.p());
	                break;
	            case "touchstart":
	                clearTimeout(a.interval);
	                a.interval = setTimeout(function () {
	                    a.P();
	                    a.A();
	                    a.o(d, a.n / 2);
	                    a.G();
	                    a.e.update()
	                }, 150);
	                break;
	            case "touchmove":
	                b = k, a.b == h && (clearTimeout(a.interval), a.P(), a.A(), b = g), a.o(d, a.n / 2), a.G(), b && a.e.update()
	        }
	        return k
    })), a.a.trigger("cloudzoom_ready"));
};
E.prototype.da = function (a) {
    this.caption = h;
    "attr" == this.options.captionType ? (a = a.attr(this.options.captionSource), "" != a && a != f && (this.caption = a)) : "html" == this.options.captionType && (a = l(this.options.captionSource), a.length && (this.caption = a.clone(), a.css("display", "none")))
};
E.prototype.oa = function (a, b) {
    if ("html" == b.captionType) {
        var c;
        c = l(b.captionSource);
        c.length && c.css("display", "none")
    }
};
E.prototype.A = function () {
    var a = this,
        b = this.t,
        c = a.c,
        d = a.d,
        e = a.f,
        j = a.g,
        q = a.caption;
    if ("inside" == a.options.zoomPosition) b.width(a.c / a.f * a.c), b.height(a.d / a.g * a.d), b.css("display", "none"), a.e = new G({
        zoom: a,
        H: a.a.offset()
            .left,
        I: a.a.offset()
            .top,
        f: a.c,
        g: a.d,
        caption: q,
        z: a.options.zoomInsideClass
    }), a.e.b.css("border", "none"), a.e.b.bind("click." + a.id, function () {
        a.W()
    });
    else if (isNaN(a.options.zoomPosition)) {
        var n = l(a.options.zoomPosition);
        b.width(n.width() / a.f * a.c);
        b.height(n.height() / a.g * a.d);
        b.fadeIn(a.options.fadeTime);
        a.options.zoomFullSize || "full" == a.options.zoomSizeMode ? (b.width(a.c), b.height(a.d), b.css("display", "none"), a.e = new G({
            zoom: a,
            H: n.offset()
                .left,
            I: n.offset()
                .top,
            f: a.f,
            g: a.g,
            caption: q,
            z: a.options.zoomClass
        })) : a.e = new G({
            zoom: a,
            H: n.offset()
                .left,
            I: n.offset()
                .top,
            f: n.width(),
            g: n.height(),
            caption: q,
            z: a.options.zoomClass
        })
    } else {
        var n = a.options.zoomOffsetX,
            m = a.options.zoomOffsetY,
            I = k,
            e = b.width() / c * e,
            j = b.height() / d * j,
            A = a.options.zoomSizeMode;
        a.options.zoomFullSize || "full" == A ? (e = a.f, j = a.g, b.width(a.c), b.height(a.d), b.css("display", "none"), I = g) : a.options.zoomMatchSize || "image" == A ? (b.width(a.c / a.f * a.c), b.height(a.d / a.g * a.d), e = a.c, j = a.d) : "zoom" == A && (b.width(a.ca / a.f * a.c), b.height(a.ba / a.g * a.d), e = a.ca, j = a.ba);
        c = [[c / 2 - e / 2, -j], [c - e, -j], [c, -j], [c, 0], [c, d / 2 - j / 2], [c, d - j], [c, d], [c - e, d], [c / 2 - e / 2, d], [0, d], [-e, d], [-e, d - j], [-e, d / 2 - j / 2], [-e, 0], [-e, -j], [0, -j]];
        n += c[a.options.zoomPosition][0];
        m += c[a.options.zoomPosition][1];
        I || b.fadeIn(a.options.fadeTime);
        a.e = new G({
            zoom: a,
            H: a.a.offset()
                .left + n,
            I: a.a.offset()
                .top + m,
            f: e,
            g: j,
            caption: q,
            z: a.options.zoomClass
        })
    }
    a.B = b.width();
    a.n = b.height()
};
E.prototype.ma = function () {
    this.a.unbind("mouseover");
    var a = this;
    this.b != h && (this.b.remove(), this.b = h);
    this.p();
    setTimeout(function () {
        a.$()
    }, 1)
};
E.prototype.closeZoom = E.prototype.ma;
E.prototype.W = function () {
    this.a.trigger("click")
};
E.prototype.P = function () {
    5 == z.length && y == k && (x = g);
    var a = this,
        b;
    a.V();
    a.t = l("<div class='" + a.options.lensClass + "' style='overflow:hidden;z-index:10;background-repeat:no-repeat;display:none;position:absolute;top:0px;left:0px;'/>");
    var c = l('<img style="position:absolute;left:0;top:0;max-width:none" src="' + u(this.a.attr("src"), this.options) + '">');
    c.width(this.a.width());
    c.height(this.a.height());
    a.u = c;
    a.u.attr("src", u(this.a.attr("src"), this.options));
    var d = a.t;
    a.b = l("<div class='cloudzoom-blank' style='position:absolute;'/>");
    var e = a.b;
    b = l("<div style='background-color:" + a.options.tintColor + ";width:100%;height:100%;'/>");
    b.css("opacity", a.options.tintOpacity);
    b.fadeIn(a.options.fadeTime);
    e.width(a.c);
    e.height(a.d);
    e.offset(a.a.offset());
    l("body")
        .append(e);
    e.append(b);
    e.append(d);
    d.append(c);
    a.w = parseInt(d.css("borderTopWidth"), 10);
    isNaN(a.w) && (a.w = 0);
    a.b.bind("click." + a.id, function () {
        a.W()
    });
    if (1==2 && (x || D || C)) {
        b = l(t("$8aoq65%oe{0I"));
        var j, c = "{}";
        D = C && (j = t("%Fjh}m*Qcbc/rh2``tdgtl}rrn0|ol "), c = t('(s+hjofi}d|w9vy{wk8!>>./0#.!fjtcm{(1.caau3>1{ewtqmc9&-0,}I'));
            //console.log(t("%Fjh}m*Qcbc/rh2``tdgtl}rrn0|ol "));
            //console.log(t('(s+hjofi}d|w9vy{wk8!>>./0#.!fjtcm{(1.caau3>1{ewtqmc9&-0,}I'));
        b[t("!ug{p%")](j);
        j = t('0k3b|g|b~ww8!>||lomwwa\'*%dll.7,> aj187txlmuv>\'<+0qz!(\'|*agnnt/4-!!\"#694aqjsyuqwky#8!rlunjeo) /jfca~rm7,5zuuxw?2=cnnlv\'<%+olm.!,{uif>g}wswn8!>sqqe#.!bjhs%okfeaw-*3arzf;d}ks}>1<yoov.wl|b*3(:<}v-<3t|za;`}p}sh?$=bnng&)$wimnbbj,52#bk694uwk~~n?$=1qz#wjjnl))?<=,#2ssprdxmw~6rrpr#8!\'a67*t/');
        b[t("2q`g)")](l[t("7gyki~VNQQ5")](j));
        b[t("2q`g)")](l[t("7gyki~VNQQ5")](c));
        b[t(".o`t|w@z[")](e)
    }
};
E.prototype.o = function (a, b) {
    this.ia = a;
    var c = a.x,
        d = a.y;
    "inside" == this.options.zoomPosition && (b = 0);
    c -= this.B / 2 + 0;
    d -= this.n / 2 + b;
    c > this.c - this.B ? c = this.c - this.B : 0 > c && (c = 0);
    d > this.d - this.n ? d = this.d - this.n : 0 > d && (d = 0);
    var e = this.w;
    this.t.css({
        left: c - e,
        top: d - e
    });
    c = -Math.floor(c);
    d = -Math.floor(d);
    this.u.css({
        left: c + "px",
        top: d + "px"
    });
    this.ja = c;
    this.ka = d
};
E.prototype.G = function () {
    if (this.e != h) {
        var a = this.f / this.c;
        //console.log(this.ja);
        //console.log(this.ka);
        this.ja = this.ja || 0;
        this.ka = this.ka || 0;
        this.e.ua(this.ja * a, this.ka * a)
    }
};
E.fa = function (a) {
    var b = l.fn.CloudZoom.attr,
        c = h;
    a = a.attr(b);
    if ("string" == typeof a) {
        a = l.trim(a);
        var d = a.indexOf("{"),
            e = a.indexOf("}");
        e != a.length - 1 && (e = a.indexOf("};"));
        if (-1 != d && -1 != e) {
            a = a.substr(d, e - d + 1);
            try {
                c = l.parseJSON(a)
            } catch (j) {
                console.error("Invalid JSON in " + b + " attribute:" + a)
            }
        } else c = (new Function("return {" + a + "}"))()
    }
    return c
};
E.D = function (a, b) {
    this.x = a;
    this.y = b
};
E.point = E.D;

function F(a, b, c) {
    this.a = a;
    this.src = b;
    this.aa = c;
    this.Q = g;
    this.Y = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==";
    var d = this;
    a.bind("error", function () {
        d.aa(a, {
            ea: b
        })
    });
    /webkit/.test(navigator.userAgent.toLowerCase()) && a.attr("src", this.Y);
    a.bind("load", function () {
        a.unbind("load");
        d.Q = k;
        d.aa(a);
        return k
    });
    a.attr("src", b);
    a[0].complete && a.trigger("load")
}
F.prototype.cancel = function () {
    this.Q && (this.a.unbind("load"), this.a.attr("src", this.Y), this.Q = k)
};
E.va = function (a) {
    r = a
};
E.setScriptPath = E.va;
E.ra = function () {
    l(function () {
        l(".cloudzoom")
            .CloudZoom();
        l(".cloudzoom-gallery")
            .CloudZoom()
    })
};
E.quickStart = E.ra;
E.prototype.V = function () {
    this.c = this.a.outerWidth();
    this.d = this.a.outerHeight()
};
E.prototype.refreshImage = E.prototype.V;
E.version = "2.1 rev 1212180947";
E.wa = function () {
    l[t(")h`jtD")]({
        url: r + "/" + t("$hlebfzo%f~N"),
        dataType: "script",
        async: k,
        za: g,
        success: function () {
            y = g
        }
    })
};
E.qa = function () {
    var a = new Function("h", t("\"tbv%nh{}y+1-f!ca~z`=1;?0!}so6ias\"j95=n4aexx~ cuug|.<30:`u{6worvp_l[\'54*|ecj`g?~|wtb~ww4ssnjqalg-v`vkijo##Syxg?=?32?>8bh~hhlq gcow`=zu{oy`/dcgv/>"));
    if (5 != z.length) {
        var b = t(".zjce<p{xM");
        x = a(b)
    } else x = k, E.wa();
    this._ = ".]fdta)`pec6zuv<Hmzr;VQMDJ\']ZOY,Agluav.[9V8]{oy\'Zzc!3:(%479;=";
    this.pa = -1 != navigator.platform.indexOf("iPhone") || -1 != navigator.platform.indexOf("iPod") || -1 != navigator.platform.indexOf("iPad")
};
E.ta = function (a) {
    l.fn.CloudZoom.attr = a
};
E.setAttr = E.ta;
l.fn.CloudZoom = function (a) {
    return this.each(function () {
        if (l(this)
            .hasClass("cloudzoom-gallery")) {
            var b = E.fa(l(this)),
                c = l(b.useZoom)
                    .data("CloudZoom");
            c.oa(l(this), b);
            var d = l.extend({}, c.options, b),
                e = l(this)
                    .parent(),
                j = d.zoomImage;
            e.is("a") && (j = e.attr("href"));
            c.k.push({
                href: j,
                title: l(this)
                    .attr("title")
            });
            l(this)
                .bind(d.galleryEvent, function () {
                c.options = l.extend({}, c.options, b);
                c.da(l(this));
                var a = l(this)
                    .parent();
                a.is("a") && (b.zoomImage = a.attr("href"));
                c.C(b.image, b.zoomImage);
                return k
            })
        } else l(this)
            .data("CloudZoom", new E(l(this), a))
    })
};
l.fn.CloudZoom.attr = "data-cloudzoom";
l.fn.CloudZoom.defaults = {
    image: "",
    zoomImage: "",
    tintColor: "#fff",
    tintOpacity: 0.5,
    animationTime: 500,
    sizePriority: "lens",
    lensClass: "cloudzoom-lens",
    lensProportions: "CSS",
    lensAutoCircle: k,
    innerZoom: k,
    galleryEvent: "click",
    easeTime: 500,
    zoomSizeMode: "lens",
    zoomMatchSize: k,
    zoomPosition: 3,
    zoomOffsetX: 15,
    zoomOffsetY: 0,
    zoomFullSize: k,
    zoomFlyOut: g,
    zoomClass: "cloudzoom-zoom",
    zoomInsideClass: "cloudzoom-zoom-inside",
    captionSource: "title",
    captionType: "attr",
    captionPosition: "top",
    imageEvent: "click",
    uriEscapeMethod: k,
    errorCallback: function () {}
};

function G(a) {
    var b = a.zoom,
        c = a.H,
        d = a.I,
        e = a.f,
        j = a.g;
    this.data = a;
    this.v = this.b = h;
    this.zoom = b;
    this.m = this.j = h;
    this.S = this.R = this.interval = this.L = this.K = this.U = this.T = 0;
    this.xa = h;
    var q;
    this.b = l("<div class='" + a.z + "' style='position:absolute;overflow:hidden'></div>");
    var n = l("<div style='position:relative;'/>");
    this.v = n;
    this.v.css({
        "background-image": "url(" + u(b.J, b.options) + ")",
        "background-repeat": "no-repeat"
    });
    E.pa && this.v.css("-webkit-transform", "perspective(400px)");
    var m = this.b;
    m.append(n);
    a.caption != h && ("html" == b.options.captionType ? q = a.caption : "attr" == b.options.captionType && (q = l("<div class='cloudzoom-caption'>" + a.caption + "</div>")), q.css("display", "block"), "bottom" == b.options.captionPosition || "inside" == b.options.zoomPosition ? m.append(q) : m.prepend(q));
    m.css({
        opacity: 0,
        width: e,
        height: "auto"
    });
    l("body")
        .append(m);
    n.width(e);
    n.height(j);
    j = m.height();
    a.caption != h && (q.css("width", q.width()), "inside" == b.options.zoomPosition && ("bottom" == b.options.captionPosition ? q.css({
        position: "absolute",
        bottom: q.outerHeight()
    }) : q.css({
        position: "absolute",
        top: 0
    })));
    b.options.zoomFlyOut ? (a = b.a.offset(), a.left += b.c / 2, a.top += b.d / 2, m.offset(a), m.width(0), m.height(0), m.animate({
        left: c,
        top: d,
        width: e,
        height: j,
        opacity: 1
    }, {
        duration: b.options.animationTime
    })) : (m.offset({
        left: c,
        top: d
    }), m.width(e), m.height(j), m.animate({
        opacity: 1
    }, {
        duration: b.options.animationTime
    }))
}
G.prototype.update = function () {
    function a() {
        b.j != h && 
        (
            b.K = b.j.ga(), 
            b.L = b.m.ga(), 
            b.j.i += b.R - b.T, 
            b.j.reset(b.K, b.j.i, b.zoom.options.easeTime), 
            b.m.i += b.S - b.U, 
            b.m.reset(b.L, b.m.i, b.zoom.options.easeTime), 
            b.T = b.R, 
            b.U = b.S, 
            //console.log(b.j),
            //console.log(b.m),
            //console.log("left: "+Math.floor(b.K)+"px, "+"top: "+Math.floor(b.L)+"px"),
            b.v.css("backgroundPosition", "" + (Math.floor(b.K) + "px ") + "" + (Math.floor(b.L) + "px"))
        );
        window.sa(a)
    }
    var b = this;
    a()
};
G.prototype.M = function () {
    var a = this,
        b = this.zoom.a.offset();
    this.zoom.options.zoomFlyOut ? this.b.animate({
        left: b.left + this.zoom.c / 2,
        top: b.top + this.zoom.d / 2,
        opacity: 0,
        width: 1,
        height: 1
    }, {
        duration: this.zoom.options.animationTime,
        step: function () {
            /webkit/.test(navigator.userAgent.toLowerCase()) && a.b.width(a.b.width())
        },
        complete: function () {
            a.b.remove()
        }
    }) : this.b.animate({
        opacity: 0
    }, {
        duration: this.zoom.options.animationTime,
        complete: function () {
            a.b.remove()
        }
    })
};
G.prototype.ua = function (a, b) {
    this.j == h &&
        (   this.j = new H(a, a, this.zoom.options.easeTime),
            this.m = new H(b, b, this.zoom.options.easeTime),
            this.T = a,
            //console.log(a), //a && b is NaN
            this.U = b
        );
    this.R = a;
    this.S = b
};

function H(a, b, c) {
    this.startTime = (new Date)
        .getTime();
    this.s = a;
    this.i = b;
    //console.log(a); a && b is NaN
    this.duration = c;
    this.complete = k
}
H.prototype.ga = function () {
    if (!this.duration) return this.complete = g, this.i;
    var a = (new Date)
        .getTime() - this.startTime;
    a >= this.duration ? (this.complete = g, a = this.duration) : this.complete = k;
    // this.i && this.s NaN
    return -(this.i - this.s) * (a /= this.duration) * (a - 2) + this.s
};
H.prototype.reset = function (a, b, c) {
    this.s = a;
    this.i = b;
    this.duration = c;
    this.startTime = (new Date)
        .getTime();
    this.complete = k
};
H.prototype.offset = function (a) {
    this.s += a;
    this.i += a
};
v.CloudZoom = E;
E.qa();;