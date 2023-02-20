build: codegen/codegen-src/Gen
	elm make src/Main.elm --debug --output=public/main.bundle.js

clean:
	rm -rf codegen/codegen-src/Gen
	rm -rf public/main.bundle.js
	rm -rf generated

codegen: codegen/codegen-src/Gen
	npx @abradley2/elm-codegen run --flags-from="public/translations.en.json"
	npx @abradley2/elm-codegen run --flags-from="star-wars-armada-data/ship-cards.json"
	npx @abradley2/elm-codegen run --flags-from="star-wars-armada-data/upgrade-cards.json"

codegen/codegen-src/Gen:
	npx @abradley2/elm-codegen install

review-fix:
	elm-review src/ --fix

review:
	elm-review src/