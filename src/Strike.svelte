<script>
  import nouns from '../corpora/data/words/nouns.json'
  import verbs from '../corpora/data/words/verbs.json'

  import { capitalise, getRandomEntry } from './utils.js'

  let strike_name = ''
  let strike_details = ''

  function generateStrikeName() {
    strike_name = capitalise(getRandomEntry(nouns['nouns'])) + capitalise(getRandomEntry(verbs['verbs'])['present'])
  }

  function generateStrikeDetails() {
    strike_details = "..."
  }

  generateStrikeName()
  generateStrikeDetails()

</script>

<section>
  <h1 on:click={generateStrikeName}>Operation... {strike_name}?</h1>
  <p on:click={generateStrikeDetails}>{strike_details}</p>
</section>
