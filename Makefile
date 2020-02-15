TOTAL=$(shell cat params.json | sh ./fetch.sh | jq ".TotalResults")
PAGES=$(shell seq 0 1 $(TOTAL) | xargs printf "pages/%d.json\n")

all: $(PAGES)

pages/%.json:
	cat params.json | jq -c ".QueryFilters.skip.Query = $* | .From = $*" | sh ./fetch.sh > $@ 

pages.csv: $(PAGES)
	find pages -name "*.json" -exec cat {} + | jq -r ".Results | map(.Data)" | json2csv > $@

