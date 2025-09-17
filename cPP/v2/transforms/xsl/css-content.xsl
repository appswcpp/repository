<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cc="https://niap-ccevs.org/cc/v1" xmlns:htm="http://www.w3.org/1999/xhtml">


   <!--##############################################
      ##############################################-->
 <!-- Common CSS rules for all files-->
  <xsl:template name="common_css">
    #toc a{
        display: block;
    }
    .td-{
        display: block;
    }
    svg{
      width: 100%;
    }

    a[id^="ajq_"]{
        color:black;
    }

    <!-- h1{ -->
    <!--    width: 100%; -->
    <!--    border-bottom-style: solid; -->
    <!--    border-bottom-color: black; -->
    <!-- } -->
    body{
       max-width: 900px;
       margin: auto;
    }
    #toc span{
       margin-left: 20px;
    }
    .assignable-content{
      font-style: italic;
    }
    .selectable-content{
      font-style: italic;
    }
    .not-selectable-content{
      font-style: italic;
      text-decoration: line-through;
    }
    .refinement{
      font-weight: bold;
    }
    div.eacategory{
      font-style: italic;
      font-weight: bold;
    }
    .activity_pane .toggler::after, .activity_pane .toggler{
       display: inline-block;
       height: auto;
       content: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8A\
       AAAPCAYAAAA71pVKAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAQOFAAEDhQGl\
       VDz+AAAAB3RJTUUH4gIXFDM7fhmr1wAAAfRJREFUKM+dkk9I02EYxz/P+25uurWR\
       tTkzI4NGl4jQgkq71K1DhnTQIDolRAQFQYSHTtGhU4e6eujQofBSFLOg0C4RUSjh\
       FnmqTTdKpj/mfv/eX4cUpmRYn9vz8v3w8D7PA/AWGADCbI4QcAb4AnAF8IBJEdX+\
       N0tEda40C4AHADviW1LFvpOX6+FwtAacVzqkGiWtwxo4F21OuPu7+yvxRNoDEhpY\
       cpzavkQyc7D76FCk+vN7j7VU6RdR4xAsikjGGP9FKrN3sPfEpajv2i2zhckR4JUG\
       UCr0erFavLkn2ytd2WPxcFOsZb74+SIQA0YPHBqIdB8Z6tChJv1m/N4P33OGAUsD\
       BIFxPNcOkq07jyeSbbo1tTu2q6vHEqU7D/ddSKcz2ZQJjBSmx925b9NjwEMAafha\
       eyQa/3Dq7O0243sCIEoRGAOA59nm5dM7OHVruzH+AkDjYEp23RrLT+U8Ub+fV0UR\
       oVyaMfVa9fqquF5GKX3ja2FCuc6yWbMipYNP755UgEdr8o2FMf5ivVYdKRfzRkRW\
       RfJTOc+2rWdAcUN5hdGP7x8viGgAXLvGbGFCKxW6tj74J3nOqVvP89M5V6kQ86UZ\
       f7lWvWWMt7Sp41VKb21uSfqnB++6kWi8BLTzL4ioq7H4tgC4z3/QAZSBxEaBXygN\
       v+jeFnAPAAAAAElFTkSuQmCC');
       max-width: 15px;
    }

    a.defined{
      color: inherit;
      text-decoration: inherit;
    }
      
    a {
      text-decoration: none;
      word-wrap: break-word;
    }
    a.abbr:link{
      color:black;
      text-decoration:none;
    }
    a.abbr:visited{
      color:black;
      text-decoration:none;
    }
    a.abbr:hover{
      color:blue;
      text-decoration:none;
    }
    a.abbr:hover:visited{
      color:purple;
      text-decoration:none;
    }
    a.abbr:active{
      color:red;
      text-decoration:none;
    }
    .note-header{
      font-weight: bold;
    }
    .note p:first-child{
      display: inline;
    }

    .indent{ margin-left:2em; }

    /* Tooltip container */
    .tooltipped {
       position: relative;
       display: inline-block;
       border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
    }

    /* Tooltip text */
    .tooltiptext {
       visibility: hidden;
       width: 120px;
       background-color: black;
       color: #fff;
       text-align: center;
       padding: 5px 0;
       border-radius: 6px;

       /* Position the tooltip text - see examples below! */
       position: absolute;
       z-index: 1;
   }

   /* Show the tooltip text when you mouse over the tooltip container */
   .tooltipped:hover .tooltiptext {
       visibility: visible;
   }
   tr.major-row{
       border-top-style: double;
   }
   tr.major-row td:first-child{
       border-right-style: ridge;
       background-color: white;
   } 
   table.mfs td{
       text-align: center;
   }
   table.mfs td:first-child{
       text-align: left;
       white-space: nowrap;
   }
  .table-caption, caption{
       text-align: center;
       font-weight: bold;
   }
   table{
       margin:auto;
       margin-top:1em;
       border-collapse:collapse; /*border: 1px solid black;*/
   }
   td{
       text-align:left;
       padding:8px 8px;
   }
   th{
       padding:8px 8px;
   }
   thead tr td{
       text-align: center;
       font-style: oblique;
       font-weight: bold;
   }
   tr.header{
       border-bottom:3px solid gray;
       padding:8px 8px;
       text-align:left;
       font-weight:bold; /*font-size: 90%; font-family: verdana, arial, helvetica, sans-serif; */
   }
   table tr:nth-child(2n+2){
       background-color:#F4F4F4;
   }

   table.ecd_heir_dep{
       width: 100%;
   }
   table.ecd_heir_dep tr{
       background-color: inherit;
   }
       
   table.ecd_heir_dep tr :first-child{
       white-space: nowrap;
   }
   table.ecd_heir_dep tr :last-child{
       width: 100%;
   }

       
   .dependent{
       border: 1px solid gray;
       border-radius: 1px
   }
   .dependent-content{
       margin-left: 25px;
       font-style: italic;
   }

   .uc_table_or td, .uc_table_or tr {
       vertical-align: middle;
       border: 1px solid black;
       background-color: white;
   }

   .uc_not, .uc_mf, .uc_sel, .uc_guide{
       text-indent: 10px;
   }
   .uc_sel > a{ 
       font-style: italic;
   }

   .uc_not_sel, .uc_sel.uc_mf, uc_assign.uc_mf{
       text-indent: 20px;
   }


   .uc_table_or tr td.or_cell{
      white-space: nowrap;
      border-radius: 0.6em 0 0 0.6em;
      background-color: black;
      color: white;
   }

   .uc_table_and, .uc_table_or {
       width: 100%;
       background-color: white;
   }
   .uc_guidance{
       display: table;
       background-color: gray;
   }  
   div.uc_inc_fcomp{
       display: list-item;
       list-style-type: disc;
       list-style-position: inside;
       }

   div.validationguidelines_label{
        padding-top: 10px;
   }
	
   .evidence, .test-obj { font-style: normal; font-size: 90%;}
   
   
	table.classic {
    	width: 100%;
    	background-color: white;
    	border-collapse: collapse;
    	border-width: 2px;
  		border-color: gray;
  		border-style: solid;
  		color: black;
		font-size: small;
	}
    table.classic th {
  		background-color: lightgray;   
	}
    table.classic th:empty{
	    background-color: white;
		border-top: none;
		border-left: none;
	}
	table.classic td, table.classic th {
  		border-width: 2px;
  		border-color: gray;
  		border-style: solid;
  		padding: 5px;
	}

   <!-- This is a description after an f-component -->
    .comp .description{
        padding-bottom: 20px;
        display: block;
    }    
   
   <!-- Include some custom css as defined by in the source PP -->
    <xsl:value-of select="//cc:extra-css"/>
  </xsl:template>

  <xsl:template name="pp_css">
        <xsl:call-template name="common_css"/>
          .figure{
              font-weight:bold;
          }
          h1{
              page-break-before:always;
              text-align:left;
              font-size:200%;
              margin-top:2em;
              margin-bottom:2em;
              font-family:verdana, arial, helvetica, sans-serif;
              margin-bottom:1.0em;
          }
          h1.title{
              text-align:center;
          }
          h2{
              font-size:125%;
              border-bottom:solid 1px gray;
              margin-bottom:1.0em;
              margin-top:2em;
              margin-bottom:0.75em;
              font-family:verdana, arial, helvetica, sans-serif;
          }
          h3{
              font-size:110%;
              margin-bottom:0.25em;
              font-family:verdana, arial, helvetica, sans-serif;
          }
          h4{
              margin-left:0%;
              font-size:100%;
              margin-bottom:0.75em;
              font-family:verdana, arial, helvetica, sans-serif;
          }
          h5,
          h6{
              margin-left:6%;
              font-size:90%;
              margin-bottom:0.5em;
              font-family:verdana, arial, helvetica, sans-serif;
          }
          p{
              margin-bottom:0.6em;
              margin-top:0.2em;
          }
          pre{
              margin-bottom:0.5em;
              margin-top:0.25em;
              margin-left:3%;
              font-family:monospace;
              font-size:90%;
          }
          ul{
              margin-bottom:0.5em;
              margin-top:0.25em;
          }
          td{
              vertical-align:top;
          }
          dl{
              margin-bottom:0.5em;
              margin-top:0.25em;
          }
          dt{
              margin-top:0.7em;
              font-weight:bold;
              font-family:verdana, arial, helvetica, sans-serif;
          }

          a.linkref{
              font-family:verdana, arial, helvetica, sans-serif;
              font-size:90%;
          }

          *.simpleText{
              margin-left:10%;
          }
          *.propertyText{
              margin-left:10%;
              margin-top:0.2em;
              margin-bottom:0.2em
          }
          *.toc{
              background:#FFFFFF;
          }
          *.toc2{
              background:#FFFFFF;
          }
	  .choicelabel{
	    font-weight: bold;
	  }
          div.comp{
              margin-left:8%;
              margin-top:1em;
              margin-bottom:1em;
          }
          div.element{
              margin-bottom:1em;
          }
          div.appnote{
              margin-left:0%;
              margin-top:1em;
          }
          .comment{
              background-color:beige;
              color:green;
          }

          div.subaact{
              margin-left:0%;
              margin-top:1em;
          }
          .subaact-header{
              font-weight: bold;
          }

          div.activity_pane_body{
              font-style:italic;
              margin-left:0%;
              margin-top:1em;
              margin-bottom:1em;
              padding:1em;
              border:2px solid #888888;
              border-radius:3px;
              display:block;
              margin-left:0%;
              margin-top:1em;
              margin-bottom:1em;
              box-shadow:0 2px 2px 0 rgba(0,0,0,.14),0 3px 1px -2px rgba(0,0,0,.2),0 1px 5px 0 rgba(0,0,0,.12);
          }
          div.optional-appendicies{
              display:none;
          }

          div.statustag{
              margin-left:0%;
              margin-top:1em;
              margin-bottom:1em;
              padding: 0.6em;
              border:2px solid #888888;
              border-radius:3px;
          }

          div.toc{
              margin-left:8%;
              margin-bottom:4em;
              padding-bottom:0.75em;
              padding-top:1em;
              padding-left:2em;
              padding-right:2em;
          }
          span.SOlist{
              font-size:90%;
              font-family:verdana, arial, helvetica, sans-serif;
          }
          h2.toc{
              border-bottom:none;
              margin-left:0%;
              margin-top:0em;
          }
          p.toc{
              margin-left:2em;
              margin-bottom:0.2em;
              margin-top:0.5em;
          }
          p.toc2{
              margin-left:5em;
              margin-bottom:0.1em;
              margin-top:0.1em;
          }
          div.center{
              display:block;
              margin-left:auto;
              margin-right:auto;
              text-align:center;
              }
          div.ea{
	      padding-bottom:10px;
          }
	      
          div.figure{
              display:block;
              margin-left:auto;
              margin-right:auto;
              text-align:center;
              margin-top:1em;
          }
          div.activity_pane_header{
              display:table-cell;
              vertical-align:middle;
              padding-top:10px;
          }
          span.activity_pane_label{
              vertical-align:middle;
              color:black;
              text-decoration:none;
              font-size:100%;
              font-weight:bold; /*font-family: verdana, arial, helvetica, sans-serif; */
          }
          .dyn-abbr a, .dyn-abbr a:active, .dyn-abbr a:visited{
              background-color: inherit;
              color: inherit;
              text-decoration: inherit;;
          }

          @media screen{
              *.reqid{
                  float:left;
                  font-size:90%;
                  font-family:verdana, arial, helvetica, sans-serif;
                  margin-right:1em;
              }
              *.req{
                  margin-left:0%;
                  margin-top:1em;
                  margin-bottom:1em;
              }
              *.reqdesc{
                  margin-left:20%;
              }

              .activity_pane.hide .toggler::after, .activity_pane.hide .toggler{
	          content: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8A\
		  AAAPCAYAAAA71pVKAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAQOFAAEDhQGl\
		  VDz+AAAAB3RJTUUH4gIXFC4BR3keeQAAAfZJREFUKM+d0k1PE1EUBuB37h2nQ+30\
		  w5YObR0FhIppqBgWuDCaSBQjiQZNTIxLfoAkBHXh2vg7xID+ABPXBl3UdAMaN1CR\
		  j5ZijZ22DKW9d44LP1KMROvZnMU5z+KcvBzAAgADwCdV1RzXlYQ26tYhrYM6u/qX\
		  ATwCcKodrAOYv3z9IV28OuP6/NHPAGYZ45G/QQ5AAFjNbyzdTA2NewcGx7xeI5wu\
		  FZenQOQQuasHncN/9IJo1sn+unkpbqVFIJhgydQo13VjDKCJSnnLBJAHUPoTBoA3\
		  uzvlfiNgDhn+KMiVCB6xYCZSoaPHz5wrba/cbuztpBWFvQLI+R2DSGZqleKNuJX2\
		  cVVjAIExDo/uV7pPjGhSNntrleI9+n7Ox33Y549Wq/ZWTyh8rNcfjPlaZ4xzZvUM\
		  ezrNvnJ+fXFCiL2k2rpQq2wnAqH4tYjZFyZq/Y8CKZoim51z1nIZQ4jGNIC5fZhz\
		  7fHA4JVuj26AyIWiMDSbdTi1L/T29RO7ahdfKgqbInJLANCKZ6Kx5J24dVowztW6\
		  Y+8WNt91FNYXc4WN988BzAL4QOT+Aj/x8GFf+MHI+UlI2cBS9kVlLZfxSFdMS9GY\
		  V1WtKETDPShhz85emLRHx++TETBLAJ4qCov8c7ajsZMr/5PtBQB3AXSpqsbagd8A\
		  O+HMRUtPNsQAAAAASUVORK5CYII=');
              }

              .activity_pane.hide .activity_pane_body{
                  display:none;
              }
              div.statustag{
                  box-shadow:4px 4px 3px #888888;
              }
          }


          @media print{
              *.reqid{
                  font-size:90%;
                  font-family:verdana, arial, helvetica, sans-serif;
              }
              *.req{
                  margin-left:0%;
                  margin-top:1em;
                  margin-bottom:1em;
              }
              *.reqdesc{
                  margin-left:20%;
              }
              div.activity_pane_body{
                  padding:1em;
                  border:2px solid #888888;
                  border-radius:3px;
                  display:block;
              }

	            img[src="images/collapsed.png"] { display:none;}

          }
    </xsl:template>

</xsl:stylesheet>
