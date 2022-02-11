<script>
  import tracery from 'tracery-grammar'
  import grammar from './grammar.json'

  import nouns from '../corpora/data/words/nouns.json'
  import verbs from '../corpora/data/words/verbs.json'
  import clothing from '../corpora/data/objects/clothing.json'
  import instruments from '../corpora/data/music/instruments.json'
  import animals from '../corpora/data/animals/common.json'

  grammar['noun'] = nouns.nouns
  grammar['past_verb'] = verbs.verbs.map((v) => v.past)
  grammar['present_verb'] = verbs.verbs.map((v) => v.present)
  grammar['clothing'] = clothing.clothes
  grammar['instrument'] = instruments.instruments
  grammar['animal'] = animals.animals

  let generator = tracery.createGrammar(grammar)
  let strike_name = ''

  generator.addModifiers(tracery.baseEngModifiers);

  function generateStrike() {
    strike_name = generator.flatten('#strike_name#')
  }

  generateStrike();
</script>

<div on:click={generateStrike}>
  <h1>Operation...</h1>
  <strong>{strike_name}?</strong>
</div>
