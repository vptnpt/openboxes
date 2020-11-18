<%@ page contentType="text/html;charset=UTF-8" defaultCodec="html" %>
<html>
<head>
    <title><g:message code="report.requestDetailReport.label" default="Request Detail Report"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="custom" />
</head>
<body>
<div class="body">
    <div class="yui-gf">
        <div class="yui-u first">
            <div class="box">
                <h2><warehouse:message code="report.parameters.label" default="Parameters"/></h2>
                    <div class="filters">
                        <div class="parameters">
                            <div class="filter-list-item">
                                <label>
                                    <warehouse:message code="request.fulfillingLocation.label"/>
                                </label>
                                <g:selectLocation class="chzn-select-deselect filter"
                                                  id="origin"
                                                  name="origin.id"
                                                  noSelection="['':'']"
                                                  groupBy="locationType"
                                                  value="${params?.origin}"/>
                            </div>
                            <div class="filter-list-item">
                                <label><warehouse:message code="requisition.dateIssuedBetween.label" default="Date Issued Between"/></label>
                                <div>
                                    <g:jqueryDatePicker name="startDate" value="${params.startDate}" autocomplete="off" format="dd/MMM/yyyy" />
                                    <g:jqueryDatePicker name="endDate" value="${params.endDate}" autocomplete="off" format="dd/MMM/yyyy" />
                                </div>
                            </div>

                            <h2><warehouse:message code="report.optionalFilters.label" default="Optional Filters"/></h2>
                            <div class="filter-list-item">
                                <label><warehouse:message code="product.label"/></label>
                                <p>
                                    <g:autoSuggest id="product" name="product" styleClass="text"
                                                   jsonUrl="${request.contextPath }/json/findProductByName?skipQuantity=true"/>
                                </p>
                            </div>
                            <div class="filter-list-item">
                                <label><warehouse:message code="requisitionItem.cancelReasonCode.label"/></label>
                                <p>
                                    <g:selectRequestReasonCode name="reasonCode"
                                                        id="reasonCode"
                                                        noSelection="['':'']"
                                                        value="${params?.reasonCode}"
                                                        class="chzn-select-deselect"/>
                                </p>
                            </div>
                            <div class="filter-list-item">
                                <label>
                                    <warehouse:message code="default.destination.label"/>
                                </label>
                                <g:selectLocation class="chzn-select-deselect filter"
                                                  id="destinationId"
                                                  name="destination.id"
                                                  noSelection="['':'']"
                                                  groupBy="locationType"
                                                  value="${params?.destination?.id}"/>
                            </div>
                        </div>
                        <div class="buttons">
                            <button class="submit-button button">
                                <img src="${createLinkTo(dir:'images/icons/silk',file:'play_blue.png')}" />
                                <g:set var="reportLabel" value="${g.message(code:'default.report.label', default: 'Report')}"/>
                                ${g.message(code: 'default.run.label', args: [reportLabel])}
                            </button>
                            <button class="download-button button">
                                <img src="${createLinkTo(dir:'images/icons/silk',file:'page_excel.png')}" />
                                <g:set var="dataLabel" value="${g.message(code:'default.data.label', default: 'Data')}"/>
                                ${g.message(code: 'default.download.label', args: [dataLabel])}
                            </button>
                        </div>
                    </div>
            </div>
        </div>
        <div class="yui-u">
            <div class="box">
                <h2 class="middle">
                    <g:message code="${'report.listRequestItems.label'}" default="${'List Completed Request Items'}"/>
                </h2>
                <div class="dialog">
                    <table id="requestDetailReportTable" class="dataTable">
                        <thead>
                            <tr class="prop">
                                <th class="center"><g:message code="requisition.requestNumber.label"/></th>
                                <th class="center"><g:message code="requisition.dateRequested.label"/></th>
                                <th class="center"><g:message code="requisition.dateIssued.label"/></th>
                                <th class="center"><g:message code="default.origin.label"/></th>
                                <th class="center"><g:message code="default.destination.label"/></th>
                                <th class="center"><g:message code="default.code.label"/></th>
                                <th class="center"><g:message code="product.label"/></th>
                                <th class="center"><g:message code="requisition.qtyRequested.label"/></th>
                                <th class="center"><g:message code="requisition.qtyIssued.label"/></th>
                                <th class="center"><g:message code="requisitionItem.reasonCodes.label"/></th>
                                <th class="center"><g:message code="requisition.qtyDemand.label"/></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th colspan="9"/>
                                <th><g:message code="report.totalDemand.label"/></th>
                                <th id="totalDemand"></th>
                            </tr>
                            <tr>
                                <th colspan="9"/>
                                <th><g:message code="report.averageMonthlyDemand.label"/></th>
                                <th id="averageMonthlyDemand"></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="loading">Loading...</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.25.3/moment.min.js"></script>
<script type="text/javascript" charset="utf8" src="//cdnjs.cloudflare.com/ajax/libs/datatables/1.9.4/jquery.dataTables.js"></script>
<script>
    function initializeDataTable() {
      var options = {
        "bDestroy": true,
        "bProcessing": true,
        "iDisplayLength": 100,
        "bSearch": false,
        "bScrollCollapse": true,
        "bJQueryUI": true,
        "bAutoWidth": true,
        "bScrollInfinite": true,
        "sScrollY": 500,
        "sPaginationType": "two_button",
        "sAjaxSource": "${request.contextPath}/json/getRequestDetailReport",
        "fnServerParams": function ( data ) {
          data.push({ name: "destinationId", value: $("#destinationId").val() });
          data.push({ name: "originId", value: $("#origin").val() });
          data.push({ name: "startDate", value: $("#startDate").val() });
          data.push({ name: "endDate", value: $("#endDate").val() });
          data.push({ name: "productId", value: $("#product-id").val() });
          data.push({ name: "reasonCode", value: $("#reasonCode").val() });
        },
        "fnServerData": function ( sSource, aoData, fnCallback ) {
          $.ajax( {
            "dataType": 'json',
            "type": "POST",
            "url": sSource,
            "data": aoData,
            "success": fnCallback,
            "timeout": 30000,
            "error": handleAjaxError,
            beforeSend : function(){
              $(".loading").show();
            },
            complete: function(){
              $(".loading").hide();
            },
          } );
        },
        "fnFooterCallback": function (nRow, aaData, iStart, iEnd) {
          var totalDemand = 0;
          for (var i = iStart; i < iEnd; i++) {
            totalDemand += aaData[i].quantityDemand;
          }
          nRow.getElementsByTagName('th')[2].innerHTML = totalDemand;
          var secondRow = $(nRow).next()[0];
          var startDate = moment($('#startDate').val());
          var endDate = moment($('#endDate').val());
          var monthsDifference = endDate.diff(startDate, 'months');
          secondRow.getElementsByTagName('th')[2].innerHTML = Math.round(totalDemand / (monthsDifference * 30));
        },
        "oLanguage": {
          "sZeroRecords": "No records found",
          "sProcessing": "Loading <img alt='spinner' src='${request.contextPath}/images/spinner.gif' /> Loading... "
        },
        "aLengthMenu": [
          [5, 15, 25, 100, 1000, -1],
          [5, 15, 25, 100, 1000, "All"]
        ],
        "aoColumns":
          [
            { "mData": "requestNumber" },
            { "mData": "dateRequested" },
            { "mData": "dateIssued" },
            { "mData": "origin" },
            { "mData": "destination" },
            { "mData": "productCode" },
            { "mData": "productName" },
            { "mData": "quantityRequested"},
            { "mData": "quantityIssued"},
            { "mData": "reasonCode"},
            { "mData": "quantityDemand"},
          ],
        "dom": '<"top"i>rt<"bottom"flp><"clear">',
        "aaSorting": [[ 0, "asc" ]],
      };

      $('#requestDetailReportTable').dataTable(options);
    }

    function handleAjaxError( xhr, status, error ) {
      if ( status === 'timeout' ) {
        $.notify("The server took too long to send the data", "error");
      }
      else {
        // User probably refreshed page or clicked on a link, so this isn't really an error
        if(xhr.readyState == 0 || xhr.status == 0) {
          return;
        }
        $.notify("An error occurred on the server. Please contact your system administrator.", "error");
      }
    }

    $(document).ready(function() {
        $(".loading").hide();
        $('#requestDetailReportTable').dataTable({"bJQueryUI": true});
        $(".download-button").click(function(event) {
          event.preventDefault();
          var params = {
            destinationId: $("#destinationId").val(),
            originId: $("#origin").val(),
            startDate: $("#startDate").val(),
            endDate: $("#endDate").val(),
            productId: $("#product-id").val(),
            reasonCode: $("#reasonCode").val(),
            format: "text/csv"
          };
          var queryString = $.param(params, true);
          window.location.href = '${request.contextPath}/json/getRequestDetailReport?' + queryString;
        });

      $(".submit-button").click(function(event){
        event.preventDefault();
        var originId = $("#origin").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        var validated = true;

        if (!endDate || !startDate || !originId) {
          $.notify("All report parameters fields are required", "error");
          validated = false
        }

        startDate = Date.parse(startDate);
        endDate = Date.parse(endDate);

        if (startDate > endDate) {
          $.notify("Start date must occur before end date", "error");
          validated = false
        }

        if (validated) {
          initializeDataTable();
        }
      });
  });

</script>
</body>
</html>