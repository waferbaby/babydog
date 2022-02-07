<script>
import nouns from '../corpora/data/words/nouns.json'
import verbs from '../corpora/data/words/verbs.json'

import tracery from 'tracery-grammar'
import grammar from './grammar.json'

grammar['noun'] = nouns.nouns
grammar['present_verb'] = verbs.verbs.map((v) => v.present)
grammar['past_verb'] = verbs.verbs.map((v) => v.past)

let generator = tracery.createGrammar(grammar)
let strike_name = ''
let strike_details = ''

generator.addModifiers(tracery.baseEngModifiers);

function generateStrike() {
  strike_name = generator.flatten('#strike_name#')
}

generateStrike();
</script>

<div on:click={generateStrike}>
  <h1>Operation...</h1>
  <strong>{strike_name}?</strong>
  <p>{strike_details}</p>
</div>
