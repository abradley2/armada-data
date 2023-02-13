build:
	rm -rf generated/
	npx @abradley2/elm-codegen run --flags-from="public/translations.en.json"
	npx @abradley2/elm-codegen run --flags-from="star-wars-armada-data/data/ship-card.json"
	elm make src/Main.elm --output=public/main.bundle.js

review-fix:
	elm-review src/ --fix

review:
	elm-review src/