angular.module("umbraco")
    .controller("DigiTiger.AwasController",
    function ($scope, $routeParams) {



        var textareaid = "dtawas-input-" + $routeParams.id + "-" + $scope.model.alias;
        var editorid = "dtawas-editor-" + $routeParams.id + "-" + $scope.model.alias;
        var editorwrapperid = "dtawas-editorwrapper-" + $routeParams.id + "-" + $scope.model.alias;
        var iframeid = "dtawas-editoriframe-" + $routeParams.id + "-" + $scope.model.alias;

		$scope.launchDtAwas = function(){
		    addListener(addNode);


		    function addNode() {
		        var editorwrapper = document.createElement("div");
		        editorwrapper.className = "dtawas-editorwrapper";
		        editorwrapper.id = editorwrapperid;

		        var editor = document.createElement("div");
		        editor.className = "dtawas-editor";
		        editor.id = editorid;
		        editor.style.display = "block";

		        var ifrm = document.createElement("IFRAME");
		        var iframeSrc = "/App_Plugins/DtAwas/DtDaxe_1.3/build/web/daxe.html?config=/App_Plugins/DtAwas/XmlConfigs/" + $scope.model.config.config;
		        iframeSrc += "&textareaid=" + textareaid;
		        if ($scope.model.config.xsd != null && $scope.model.config.xsd != "") {
		            iframeSrc += "&xsd=/App_Plugins/DtAwas/XmlConfigs/" + $scope.model.config.xsd;
		        }
		        if ($scope.model.config.root != null && $scope.model.config.root != "") {
		            iframeSrc += "&root=" + $scope.model.config.root;
		        }else{
		            iframeSrc += "&root=0";
		        }
		       

		        ifrm.setAttribute("src",  iframeSrc);
		        ifrm.className = "dtawas-editoriframe";
		        ifrm.id = iframeid;

		        editor.appendChild(ifrm);
		        editorwrapper.appendChild(editor);
		        document.body.appendChild(editorwrapper);
		        //callback();
		    }

		    function removeNode() {
		        var activeframe = document.getElementById(iframeid);
		        activeframe.parentNode.removeChild(activeframe);
		        var activeeditor = document.getElementById(editorwrapperid);
		        activeeditor.parentNode.removeChild(activeeditor);
		        //callback();
		    }

		    function addListener(callback) {
		        window.addEventListener("message", respondToMessage, false);
		        callback();
		    }
		    function removeListener(callback) {
		        window.removeEventListener("message", respondToMessage, false);
		        callback();
		    }
		       
		    function respondToMessage(event) {
		        var thistextareaid = QueryString(event.source.location.search).textareaid;
		        //alert("get message: from" + thistextareaid + event.data);
		        if (thistextareaid == textareaid) {
		            if (event.data == "get") {
		                //alert("sending xml");
		                event.source.postMessage($scope.model.value, window.location.href);
		            } else {
		                $scope.model.value = event.data;
		                //alert("value updated!");
		                finishEditing();
		            }
		        } else {
		            //alert("from wrong iframe");
		        }
		    }
		    function finishEditing() {
		        removeListener(removeNode);
		    }

		    function QueryString(searchstring) {
		        var query_string = {};
		        var query = searchstring.substring(1);
		        var vars = query.split("&");
		        for (var i = 0; i < vars.length; i++) {
		            var pair = vars[i].split("=");
		            // If first entry with this name
		            if (typeof query_string[pair[0]] === "undefined") {
		                query_string[pair[0]] = pair[1];
		                // If second entry with this name
		            } else if (typeof query_string[pair[0]] === "string") {
		                var arr = [query_string[pair[0]], pair[1]];
		                query_string[pair[0]] = arr;
		                // If third or later entry with this name
		            } else {
		                query_string[pair[0]].push(pair[1]);
		            }
		        }
		        return query_string;
		    }

		}

    });