package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

func read_json(name string) []string {
	//Read the json file
	var slice []string
	file, err := ioutil.ReadFile(name)
	if err != nil {
		fmt.Println("Error reading file: ", err)
	}
	err = json.Unmarshal(file, &slice)
	if err != nil {
		fmt.Println("Error parsing JSON : ", err)
	}
	return slice
}

func test_http_link(link string) string {
	_, err := http.Get("https://" + link)
	if err != nil {
		return "Failed"
	}
	return "Working"
}

func monitor(w http.ResponseWriter, req *http.Request) {
	list_of_link_to_test := read_json("http_request.json")

	fmt.Fprint(w, "Monitoring HTTP REQUESTS :\n")
	fmt.Fprint(w, "\n")

	for _, elem := range list_of_link_to_test {
		fmt.Fprint(w, elem)
		fmt.Fprint(w, " -> ")
		fmt.Fprintf(w, test_http_link(elem))
		fmt.Fprint(w, "\n")
	}

	fmt.Fprint(w, "\n")
	fmt.Fprint(w, "==========================\n")
}

func headers(w http.ResponseWriter, req *http.Request) {
	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

func main() {
	fmt.Println("==================================")
	fmt.Println("Starting JustMonitor Application !")
	fmt.Println("==================================")

	http.HandleFunc("/", monitor)

	http.ListenAndServe(":8080", nil)

	fmt.Println("==========")
	fmt.Println("Finished !")
	fmt.Println("==========")
}
