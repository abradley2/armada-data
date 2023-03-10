build: generated
	elm make src/Main.elm --debug --output=public/main.bundle.js

clean:
	rm -rf codegen/codegen-src/Gen
	rm -rf public/main.bundle.js
	rm -rf generated

generated: codegen/codegen-src/Gen
	npx @abradley2/elm-codegen run --flags-from="public/translations.en.json"
	npx @abradley2/elm-codegen run --flags-from="star-wars-armada-data/ship-cards.json"
	npx @abradley2/elm-codegen run --flags-from="star-wars-armada-data/upgrade-cards.json"

codegen/codegen-src/Gen:
	npx @abradley2/elm-codegen install

test: generated
	elm-test

review-fix:
	elm-review src/ --fix

review:
	elm-review src/