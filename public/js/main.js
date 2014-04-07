/*!
 * 
 * Python Bindings
 * Boilerplate version 0.3.0, Built on 04-07-2014
 * Copyright (c) 2014 SoftLayer, an IBM Company. All rights reserved.
 * Code and documentation licensed under MIT.
 * 
 */

(function(){!function(a){var b,c,d,e,f,g;return f=function(a){return g[a.name]||a.html_url},d=function(a){return e[a.name]||a.description},b=function(b){var c,e;c=a("<li>").addClass("repo grid-1 "+(b.language||"").toLowerCase()),e=a("<a>").attr("href",f(b)).appendTo(c),e.append(a("<h3>").text(b.name)),e.append(a("<p>").text(d(b))),e.append(a("<h4>").text(b.language)),c.appendTo("#repos")},c=function(d,e){var f;return d=d||[],e=e||1,f="https://api.github.com/orgs/softlayer/repos?callback=?&per_page=50&page="+e,a.getJSON(f,function(f){return f.data&&f.data.length>0?(d=d.concat(f.data),c(d,e+1)):a(function(){return a("#num-repos").text(d.length),a.each(d,function(a,b){var c,d,e,f,g;return b.pushed_at=new Date(b.pushed_at),e=1.146*Math.pow(10,-9),d="new Date"-Date.parse(b.pushed_at),c="new Date"-Date.parse(b.created_at),f=1,g=1.314*Math.pow(10,7),b.hotness=f*Math.pow(Math.E,-1*e*d),b.hotness+=g*b.watchers/c}),d.sort(function(a,b){return a.hotness<b.hotness?1:b.hotness<a.hotness?-1:void 0}),a.each(d,function(a,c){return b(c)}),d.sort(function(a,b){return a.pushed_at<b.pushed_at?1:b.pushed_at<a.pushed_at?-1:void 0})})})},g={"":""},e={"":""},c()}(jQuery)}).call(this),function(){var a;(a=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],$.ajax({url:"https://api.github.com/repos/softlayer/softlayer-python/milestones?state=closed/callback?",dataType:"jsonp",success:function(b){var c,d,e;return c=b.data[0],d=new Date(c.updated_at),e=a[d.getMonth()]+" "+d.getDate(),$("#date-milestone").text(e),$("#title-milestone").text(c.title)}}),$.ajax({url:"https://api.github.com/repos/softlayer/softlayer-python/commits?state=closed/callback?",dataType:"jsonp",success:function(b){var c,d,e;return c=b.data[0],d=new Date(c.commit.committer.date),e=a[d.getMonth()]+" "+d.getDate(),$("#date-commit").text(e)}}),$.ajax({url:"https://api.github.com/repos/softlayer/softlayer-python/tags?callback?",dataType:"jsonp",success:function(a){var b;return b=a.data[0],$("#num-version").text(b.name)}}),$.getJSON("https://api.github.com/orgs/softlayer/members?callback=?",function(a){var b;return b=a.data,$(function(){$("#num-members").text(b.length)})}),$.getJSON("https://api.github.com/repos/softlayer/softlayer-python/contributors?callback=?",function(a){var b;return b=a.data,$(function(){$("#num-contributors").text(b.length)})}))(jquery)}.call(this),function(){!function(a){a.fn.tocify=function(b){var c,d,e,f,g,h,i,j,k;c={showSpeed:"slow"},j=a.extend(c,b),e=a("h1").filter(function(){return this.id}),i=a(this),!e.length||e.length<3||!i.length||(d=function(a){return parseInt(a.nodeName.replace("H",""),10)},f=e.map(function(a,b){return d(b)}).get().sort()[0],h=d(e[0]),k=void 0,g="",e.on("click",function(){window.location.hash=this.id}).addClass("clickable-header").each(function(b,c){k=d(c),k===f&&a(c).addClass("top-level-header"),k===h&&(g+="<li><a href='#"+c.id+"'>"+c.innerHTML+"</a>"),h=k}),0!==j.showSpeed?i.hide().html(g).show(j.showSpeed):i.html(g))}}(jQuery)}.call(this),function(){$("#sidebar-button").click(function(a){a.preventDefault(),$("#sidebar-wrapper").toggleClass("active")}),$("#sidebar-toggle").click(function(a){a.preventDefault(),$("#sidebar-wrapper").toggleClass("active")}),$("#sidebar-button").click(function(a){return a.preventDefault(),$("#sidebar-wrapper").toggleClass("active")})}.call(this),function(){var a,b;a=document.documentElement.scrollTop||document.body.scrollTop,b=function(a,b,c){var d,e,f,g,h;h=a.scrollTop,e=b-h,f=0,g=20,(d=function(){var b;f+=g,b=Math.easeInOutQuad(f,h,e,c),a.scrollTop=b,c>f&&setTimeout(d,g)})()},window.onscroll=function(){return pageYOffset>=200?(document.getElementById("scroll-up").style.visibility="visible",void(document.getElementById("scroll-up").onclick=function(){b(document.body,0,0)})):void(document.getElementById("scroll-up").style.visibility="hidden")},Math.easeInOutQuad=function(a,b,c,d){return a/=d/2,1>a?c/2*a*a+b:(a--,-c/2*(a*(a-2)-1)+b)}}.call(this);