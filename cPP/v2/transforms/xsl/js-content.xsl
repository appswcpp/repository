<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1" xmlns:htm="http://www.w3.org/1999/xhtml">

<!-- ############################ -->
<!-- Contains JavaScript for initializing the page -->
  <xsl:template name="init_js">
    <xsl:text disable-output-escaping="yes">// &lt;![CDATA[

// Called on page load to parse URL parameters and perform actions on them.
function init(){
    if(getQueryVariable("expand") == "on"){
      expand();
    }
    fixAbbrs();
}


function fixAbbrs(){
    var aa;
    var brk_els = document.getElementsByClassName("dyn-abbr");
    //
    for(aa=0; aa!=brk_els.length; aa++){
        var abbr = brk_els[aa].firstElementChild.getAttribute("href").substring(1);
        var el = document.getElementById("long_"+abbr)
        if (el==null) {
             console.log("Could not find 'long_abbr_'"+abbr);
             continue;
        }
        var abbr_def = el.textContent;
        brk_els[aa].setAttribute("title", abbr_def);
    }
}
// ]]&gt;</xsl:text>
</xsl:template>


  <xsl:template name="pp_js">
	<script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML' type="text/javascript"></script>
        <script type="text/x-mathjax-config">
            MathJax.Hub.Config({
            extensions: ["tex2jax.js"],
            jax: ["input/TeX", "output/HTML-CSS"],
            showMathMenu: false,
            tex2jax: {
              inlineMath: [ ['$','$'], ["\\(","\\)"] ],
              displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
              processEscapes: true
            },
            styles: {

                ".MathJax_Display": {
                "text-align": "left !important",
                margin:       "0em 0em !important"
            }}
            });
        </script>
        <script type="text/javascript">

<xsl:call-template name="init_js"/>

<xsl:text disable-output-escaping="yes">// &lt;![CDATA[
const AMPERSAND=String.fromCharCode(38);

// Pass a URL variable to this function and it will return its value
function getQueryVariable(variable)
{
    var query = window.location.search.substring(1);
    var vars = query.split(AMPERSAND);
    for (var i=0;i!=vars.length;i++) {
        var pair = vars[i].split("=");
        if(pair[0] == variable){return pair[1];}
    }
    return(false);
}


//    Expands all evaluation activities
function expand(){
    var ap = document.getElementsByClassName('activity_pane');
    for (var ii = 0; ii!=ap.length; ii++) {
        ap[ii].classList.remove('hide');
    }
}

// Function to expand and contract a given div
function toggle(descendent) {
    var cl = descendent.parentNode.parentNode.classList;
    if (cl.contains('hide')){
      cl.remove('hide');
    }
    else{
      cl.add('hide');
    }
}

// Expands targets if they are hidden
function showTarget(id){
    var element = document.getElementById(id);
    while (element != document.body.rootNode ){
	element.classList.remove("hide");
	element = element.parentElement;
    }
}


// ]]&gt;</xsl:text>
        </script>
   </xsl:template>

</xsl:stylesheet>
