
(function(l, r) { if (!l || l.getElementById('livereloadscript')) return; r = l.createElement('script'); r.async = 1; r.src = '//' + (self.location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1'; r.id = 'livereloadscript'; l.getElementsByTagName('head')[0].appendChild(r) })(self.document);
var app = (function () {
    'use strict';

    function noop() { }
    function add_location(element, file, line, column, char) {
        element.__svelte_meta = {
            loc: { file, line, column, char }
        };
    }
    function run(fn) {
        return fn();
    }
    function blank_object() {
        return Object.create(null);
    }
    function run_all(fns) {
        fns.forEach(run);
    }
    function is_function(thing) {
        return typeof thing === 'function';
    }
    function safe_not_equal(a, b) {
        return a != a ? b == b : a !== b || ((a && typeof a === 'object') || typeof a === 'function');
    }
    function is_empty(obj) {
        return Object.keys(obj).length === 0;
    }
    function append(target, node) {
        target.appendChild(node);
    }
    function insert(target, node, anchor) {
        target.insertBefore(node, anchor || null);
    }
    function detach(node) {
        node.parentNode.removeChild(node);
    }
    function element(name) {
        return document.createElement(name);
    }
    function text(data) {
        return document.createTextNode(data);
    }
    function space() {
        return text(' ');
    }
    function listen(node, event, handler, options) {
        node.addEventListener(event, handler, options);
        return () => node.removeEventListener(event, handler, options);
    }
    function children(element) {
        return Array.from(element.childNodes);
    }
    function custom_event(type, detail, bubbles = false) {
        const e = document.createEvent('CustomEvent');
        e.initCustomEvent(type, bubbles, false, detail);
        return e;
    }

    let current_component;
    function set_current_component(component) {
        current_component = component;
    }

    const dirty_components = [];
    const binding_callbacks = [];
    const render_callbacks = [];
    const flush_callbacks = [];
    const resolved_promise = Promise.resolve();
    let update_scheduled = false;
    function schedule_update() {
        if (!update_scheduled) {
            update_scheduled = true;
            resolved_promise.then(flush);
        }
    }
    function add_render_callback(fn) {
        render_callbacks.push(fn);
    }
    // flush() calls callbacks in this order:
    // 1. All beforeUpdate callbacks, in order: parents before children
    // 2. All bind:this callbacks, in reverse order: children before parents.
    // 3. All afterUpdate callbacks, in order: parents before children. EXCEPT
    //    for afterUpdates called during the initial onMount, which are called in
    //    reverse order: children before parents.
    // Since callbacks might update component values, which could trigger another
    // call to flush(), the following steps guard against this:
    // 1. During beforeUpdate, any updated components will be added to the
    //    dirty_components array and will cause a reentrant call to flush(). Because
    //    the flush index is kept outside the function, the reentrant call will pick
    //    up where the earlier call left off and go through all dirty components. The
    //    current_component value is saved and restored so that the reentrant call will
    //    not interfere with the "parent" flush() call.
    // 2. bind:this callbacks cannot trigger new flush() calls.
    // 3. During afterUpdate, any updated components will NOT have their afterUpdate
    //    callback called a second time; the seen_callbacks set, outside the flush()
    //    function, guarantees this behavior.
    const seen_callbacks = new Set();
    let flushidx = 0; // Do *not* move this inside the flush() function
    function flush() {
        const saved_component = current_component;
        do {
            // first, call beforeUpdate functions
            // and update components
            while (flushidx < dirty_components.length) {
                const component = dirty_components[flushidx];
                flushidx++;
                set_current_component(component);
                update(component.$$);
            }
            set_current_component(null);
            dirty_components.length = 0;
            flushidx = 0;
            while (binding_callbacks.length)
                binding_callbacks.pop()();
            // then, once components are updated, call
            // afterUpdate functions. This may cause
            // subsequent updates...
            for (let i = 0; i < render_callbacks.length; i += 1) {
                const callback = render_callbacks[i];
                if (!seen_callbacks.has(callback)) {
                    // ...so guard against infinite loops
                    seen_callbacks.add(callback);
                    callback();
                }
            }
            render_callbacks.length = 0;
        } while (dirty_components.length);
        while (flush_callbacks.length) {
            flush_callbacks.pop()();
        }
        update_scheduled = false;
        seen_callbacks.clear();
        set_current_component(saved_component);
    }
    function update($$) {
        if ($$.fragment !== null) {
            $$.update();
            run_all($$.before_update);
            const dirty = $$.dirty;
            $$.dirty = [-1];
            $$.fragment && $$.fragment.p($$.ctx, dirty);
            $$.after_update.forEach(add_render_callback);
        }
    }
    const outroing = new Set();
    let outros;
    function transition_in(block, local) {
        if (block && block.i) {
            outroing.delete(block);
            block.i(local);
        }
    }
    function transition_out(block, local, detach, callback) {
        if (block && block.o) {
            if (outroing.has(block))
                return;
            outroing.add(block);
            outros.c.push(() => {
                outroing.delete(block);
                if (callback) {
                    if (detach)
                        block.d(1);
                    callback();
                }
            });
            block.o(local);
        }
    }
    function create_component(block) {
        block && block.c();
    }
    function mount_component(component, target, anchor, customElement) {
        const { fragment, on_mount, on_destroy, after_update } = component.$$;
        fragment && fragment.m(target, anchor);
        if (!customElement) {
            // onMount happens before the initial afterUpdate
            add_render_callback(() => {
                const new_on_destroy = on_mount.map(run).filter(is_function);
                if (on_destroy) {
                    on_destroy.push(...new_on_destroy);
                }
                else {
                    // Edge case - component was destroyed immediately,
                    // most likely as a result of a binding initialising
                    run_all(new_on_destroy);
                }
                component.$$.on_mount = [];
            });
        }
        after_update.forEach(add_render_callback);
    }
    function destroy_component(component, detaching) {
        const $$ = component.$$;
        if ($$.fragment !== null) {
            run_all($$.on_destroy);
            $$.fragment && $$.fragment.d(detaching);
            // TODO null out other refs, including component.$$ (but need to
            // preserve final state?)
            $$.on_destroy = $$.fragment = null;
            $$.ctx = [];
        }
    }
    function make_dirty(component, i) {
        if (component.$$.dirty[0] === -1) {
            dirty_components.push(component);
            schedule_update();
            component.$$.dirty.fill(0);
        }
        component.$$.dirty[(i / 31) | 0] |= (1 << (i % 31));
    }
    function init(component, options, instance, create_fragment, not_equal, props, append_styles, dirty = [-1]) {
        const parent_component = current_component;
        set_current_component(component);
        const $$ = component.$$ = {
            fragment: null,
            ctx: null,
            // state
            props,
            update: noop,
            not_equal,
            bound: blank_object(),
            // lifecycle
            on_mount: [],
            on_destroy: [],
            on_disconnect: [],
            before_update: [],
            after_update: [],
            context: new Map(options.context || (parent_component ? parent_component.$$.context : [])),
            // everything else
            callbacks: blank_object(),
            dirty,
            skip_bound: false,
            root: options.target || parent_component.$$.root
        };
        append_styles && append_styles($$.root);
        let ready = false;
        $$.ctx = instance
            ? instance(component, options.props || {}, (i, ret, ...rest) => {
                const value = rest.length ? rest[0] : ret;
                if ($$.ctx && not_equal($$.ctx[i], $$.ctx[i] = value)) {
                    if (!$$.skip_bound && $$.bound[i])
                        $$.bound[i](value);
                    if (ready)
                        make_dirty(component, i);
                }
                return ret;
            })
            : [];
        $$.update();
        ready = true;
        run_all($$.before_update);
        // `false` as a special case of no DOM component
        $$.fragment = create_fragment ? create_fragment($$.ctx) : false;
        if (options.target) {
            if (options.hydrate) {
                const nodes = children(options.target);
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.l(nodes);
                nodes.forEach(detach);
            }
            else {
                // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
                $$.fragment && $$.fragment.c();
            }
            if (options.intro)
                transition_in(component.$$.fragment);
            mount_component(component, options.target, options.anchor, options.customElement);
            flush();
        }
        set_current_component(parent_component);
    }
    /**
     * Base class for Svelte components. Used when dev=false.
     */
    class SvelteComponent {
        $destroy() {
            destroy_component(this, 1);
            this.$destroy = noop;
        }
        $on(type, callback) {
            const callbacks = (this.$$.callbacks[type] || (this.$$.callbacks[type] = []));
            callbacks.push(callback);
            return () => {
                const index = callbacks.indexOf(callback);
                if (index !== -1)
                    callbacks.splice(index, 1);
            };
        }
        $set($$props) {
            if (this.$$set && !is_empty($$props)) {
                this.$$.skip_bound = true;
                this.$$set($$props);
                this.$$.skip_bound = false;
            }
        }
    }

    function dispatch_dev(type, detail) {
        document.dispatchEvent(custom_event(type, Object.assign({ version: '3.46.4' }, detail), true));
    }
    function append_dev(target, node) {
        dispatch_dev('SvelteDOMInsert', { target, node });
        append(target, node);
    }
    function insert_dev(target, node, anchor) {
        dispatch_dev('SvelteDOMInsert', { target, node, anchor });
        insert(target, node, anchor);
    }
    function detach_dev(node) {
        dispatch_dev('SvelteDOMRemove', { node });
        detach(node);
    }
    function listen_dev(node, event, handler, options, has_prevent_default, has_stop_propagation) {
        const modifiers = options === true ? ['capture'] : options ? Array.from(Object.keys(options)) : [];
        if (has_prevent_default)
            modifiers.push('preventDefault');
        if (has_stop_propagation)
            modifiers.push('stopPropagation');
        dispatch_dev('SvelteDOMAddEventListener', { node, event, handler, modifiers });
        const dispose = listen(node, event, handler, options);
        return () => {
            dispatch_dev('SvelteDOMRemoveEventListener', { node, event, handler, modifiers });
            dispose();
        };
    }
    function set_data_dev(text, data) {
        data = '' + data;
        if (text.wholeText === data)
            return;
        dispatch_dev('SvelteDOMSetData', { node: text, data });
        text.data = data;
    }
    function validate_slots(name, slot, keys) {
        for (const slot_key of Object.keys(slot)) {
            if (!~keys.indexOf(slot_key)) {
                console.warn(`<${name}> received an unexpected slot "${slot_key}".`);
            }
        }
    }
    /**
     * Base class for Svelte components with some minor dev-enhancements. Used when dev=true.
     */
    class SvelteComponentDev extends SvelteComponent {
        constructor(options) {
            if (!options || (!options.target && !options.$$inline)) {
                throw new Error("'target' is a required option");
            }
            super();
        }
        $destroy() {
            super.$destroy();
            this.$destroy = () => {
                console.warn('Component was already destroyed'); // eslint-disable-line no-console
            };
        }
        $capture_state() { }
        $inject_state() { }
    }

    const words = [
    'about',
    'above',
    'across',
    'act',
    'actor',
    'active',
    'activity',
    'add',
    'afraid',
    'after',
    'again',
    'age',
    'ago',
    'agree',
    'air',
    'all',
    'alone',
    'along',
    'already',
    'always',
    'amount',
    'and',
    'angry',
    'another',
    'answer',
    'any',
    'anyone',
    'anything',
    'anytime',
    'appear',
    'apple',
    'are',
    'area',
    'arm',
    'army',
    'around',
    'arrive',
    'art',
    'attack',
    'aunt',
    'autumn',
    'away',
    'able',
    'baby',
    'base',
    'back',
    'bad',
    'bag',
    'ball',
    'bank',
    'basket',
    'bath',
    'bean',
    'bear',
    'beautiful',
    'beer',
    'bed',
    'bedroom',
    'behave',
    'before',
    'begin',
    'behind',
    'bell',
    'below',
    'besides',
    'best',
    'better',
    'between',
    'big',
    'bird',
    'birth',
    'birthday',
    'bit',
    'bite',
    'black',
    'bleed',
    'block',
    'blood',
    'blow',
    'blue',
    'board',
    'boat',
    'body',
    'boil',
    'bone',
    'book',
    'border',
    'born',
    'borrow',
    'both',
    'bottle',
    'bottom',
    'bowl',
    'box',
    'boy',
    'branch',
    'brave',
    'bread',
    'break',
    'breakfast',
    'breathe',
    'bridge',
    'bright',
    'bring',
    'brother',
    'brown',
    'brush',
    'build',
    'burn',
    'business',
    'bus',
    'busy',
    'but',
    'buy',
    'cake',
    'call',
    'can',
    'candle',
    'cap',
    'car',
    'card',
    'care',
    'careful',
    'careless',
    'carry',
    'case',
    'cat',
    'catch',
    'central',
    'century',
    'certain',
    'chair',
    'chance',
    'change',
    'chase',
    'cheap',
    'cheese',
    'chicken',
    'child',
    'children',
    'chocolate',
    'choice',
    'choose',
    'circle',
    'city',
    'class',
    'clever',
    'clean',
    'clear',
    'climb',
    'clock',
    'cloth',
    'clothes',
    'cloud',
    'cloudy',
    'close',
    'coffee',
    'coat',
    'coin',
    'cold',
    'collect',
    'colour',
    'comb',
    'come',
    'comfortable',
    'common',
    'compare',
    'complete',
    'computer',
    'condition',
    'continue',
    'control',
    'cook',
    'cool',
    'copper',
    'corn',
    'corner',
    'correct',
    'cost',
    'contain',
    'count',
    'country',
    'course',
    'cover',
    'crash',
    'cross',
    'cry',
    'cup',
    'cupboard',
    'cut',
    'dance',
    'danger',
    'dangerous',
    'dark',
    'daughter',
    'day',
    'dead',
    'decide',
    'decrease',
    'deep',
    'deer',
    'depend',
    'desk',
    'destroy',
    'develop',
    'die',
    'different',
    'difficult',
    'dinner',
    'direction',
    'dirty',
    'discover',
    'dish',
    'dog',
    'door',
    'double',
    'down',
    'draw',
    'dream',
    'dress',
    'drink',
    'drive',
    'drop',
    'dry',
    'duck',
    'dust',
    'duty',
    'each',
    'ear',
    'early',
    'earn',
    'earth',
    'east',
    'easy',
    'eat',
    'education',
    'effect',
    'egg',
    'eight',
    'either',
    'electric',
    'elephant',
    'else',
    'empty',
    'end',
    'enemy',
    'enjoy',
    'enough',
    'enter',
    'equal',
    'entrance',
    'escape',
    'even',
    'evening',
    'event',
    'ever',
    'every',
    'everyone',
    'exact',
    'everybody',
    'examination',
    'example',
    'except',
    'excited',
    'exercise',
    'expect',
    'expensive',
    'explain',
    'extremely',
    'eye',
    'face',
    'fact',
    'fail',
    'fall',
    'false',
    'family',
    'famous',
    'far',
    'farm',
    'father',
    'fast',
    'fat',
    'fault',
    'fear',
    'feed',
    'feel',
    'female',
    'fever',
    'few',
    'fight',
    'fill',
    'film',
    'find',
    'fine',
    'finger',
    'finish',
    'fire',
    'first',
    'fit',
    'five',
    'fix',
    'flag',
    'flat',
    'float',
    'floor',
    'flour',
    'flower',
    'fly',
    'fold',
    'food',
    'fool',
    'foot',
    'football',
    'for',
    'force',
    'foreign',
    'forest',
    'forget',
    'forgive',
    'fork',
    'form',
    'fox',
    'four',
    'free',
    'freedom',
    'freeze',
    'fresh',
    'friend',
    'friendly',
    'from',
    'front',
    'fruit',
    'full',
    'fun',
    'funny',
    'furniture',
    'further',
    'future',
    'game',
    'garden',
    'gate',
    'general',
    'gentleman',
    'get',
    'gift',
    'give',
    'glad',
    'glass',
    'goat',
    'god',
    'gold',
    'good',
    'goodbye',
    'grandfather',
    'grandmother',
    'grass',
    'grave',
    'great',
    'green',
    'grey',
    'ground',
    'group',
    'grow',
    'gun',
    'hair',
    'half',
    'hall',
    'hammer',
    'hand',
    'happen',
    'happy',
    'hard',
    'hat',
    'hate',
    'have',
    'head',
    'healthy',
    'hear',
    'heavy',
    'hello',
    'help',
    'heart',
    'heaven',
    'height',
    'hen',
    'her',
    'here',
    'hers',
    'hide',
    'high',
    'hill',
    'him',
    'his',
    'hit',
    'hobby',
    'hold',
    'hole',
    'holiday',
    'home',
    'hope',
    'horse',
    'hospital',
    'hot',
    'hotel',
    'house',
    'how',
    'hundred',
    'hungry',
    'hour',
    'hurry',
    'husband',
    'hurt',
    'ice',
    'idea',
    'important',
    'increase',
    'inside',
    'into',
    'introduce',
    'invent',
    'iron',
    'invite',
    'island',
    'jelly',
    'job',
    'join',
    'juice',
    'jump',
    'just',
    'keep',
    'key',
    'kid',
    'kill',
    'kind',
    'king',
    'kitchen',
    'knee',
    'knife',
    'knock',
    'know',
    'ladder',
    'lady',
    'lamp',
    'land',
    'large',
    'last',
    'late',
    'lately',
    'laugh',
    'lazy',
    'lead',
    'leaf',
    'learn',
    'leave',
    'leg',
    'left',
    'lend',
    'length',
    'less',
    'lesson',
    'let',
    'letter',
    'library',
    'lie',
    'life',
    'light',
    'like',
    'lion',
    'lip',
    'list',
    'listen',
    'little',
    'live',
    'lock',
    'lonely',
    'long',
    'look',
    'lose',
    'lot',
    'love',
    'low',
    'lower',
    'luck',
    'machine',
    'main',
    'make',
    'male',
    'man',
    'many',
    'map',
    'mark',
    'market',
    'marry',
    'matter',
    'may',
    'meal',
    'mean',
    'measure',
    'meat',
    'medicine',
    'meet',
    'member',
    'mention',
    'method',
    'middle',
    'milk',
    'mill',
    'million',
    'mind',
    'mine',
    'minute',
    'miss',
    'mistake',
    'mix',
    'model',
    'modern',
    'moment',
    'money',
    'monkey',
    'month',
    'moon',
    'more',
    'morning',
    'most',
    'mother',
    'mountain',
    'mouse',
    'mouth',
    'move',
    'much',
    'music',
    'must',
    'name',
    'narrow',
    'nation',
    'nature',
    'near',
    'nearly',
    'neck',
    'need',
    'needle',
    'neighbour',
    'neither',
    'net',
    'never',
    'new',
    'news',
    'newspaper',
    'next',
    'nice',
    'night',
    'nine',
    'noble',
    'noise',
    'none',
    'nor',
    'north',
    'nose',
    'not',
    'nothing',
    'notice',
    'now',
    'number',
    'obey',
    'object',
    'ocean',
    'offer',
    'office',
    'often',
    'oil',
    'old',
    'one',
    'only',
    'open',
    'opposite',
    'orange',
    'order',
    'other',
    'our',
    'out',
    'outside',
    'over',
    'own',
    'page',
    'pain',
    'paint',
    'pair',
    'pan',
    'paper',
    'parent',
    'park',
    'part',
    'partner',
    'party',
    'pass',
    'past',
    'path',
    'pay',
    'peace',
    'pen',
    'pencil',
    'people',
    'pepper',
    'per',
    'perfect',
    'period',
    'person',
    'petrol',
    'photograph',
    'piano',
    'pick',
    'picture',
    'piece',
    'pig',
    'pill',
    'pin',
    'pink',
    'place',
    'plane',
    'plant',
    'plastic',
    'plate',
    'play',
    'please',
    'pleased',
    'plenty',
    'pocket',
    'point',
    'poison',
    'police',
    'polite',
    'pool',
    'poor',
    'popular',
    'position',
    'possible',
    'potato',
    'pour',
    'power',
    'present',
    'press',
    'pretty',
    'prevent',
    'price',
    'prince',
    'prison',
    'private',
    'prize',
    'probably',
    'problem',
    'produce',
    'promise',
    'proper',
    'protect',
    'provide',
    'public',
    'pull',
    'punish',
    'pupil',
    'push',
    'put',
    'queen',
    'question',
    'quick',
    'quiet',
    'quite',
    'radio',
    'rain',
    'rainy',
    'raise',
    'reach',
    'read',
    'ready',
    'real',
    'really',
    'receive',
    'record',
    'red',
    'remember',
    'remind',
    'remove',
    'rent',
    'repair',
    'repeat',
    'reply',
    'report',
    'rest',
    'restaurant',
    'result',
    'return',
    'rice',
    'rich',
    'ride',
    'right',
    'ring',
    'rise',
    'road',
    'rob',
    'rock',
    'room',
    'round',
    'rubber',
    'rude',
    'rule',
    'ruler',
    'run',
    'rush',
    'sad',
    'safe',
    'sail',
    'salt',
    'same',
    'sand',
    'save',
    'say',
    'school',
    'science',
    'scissors',
    'search',
    'seat',
    'second',
    'see',
    'seem',
    'sell',
    'send',
    'sentence',
    'serve',
    'seven',
    'several',
    'sex',
    'shade',
    'shadow',
    'shake',
    'shape',
    'share',
    'sharp',
    'she',
    'sheep',
    'sheet',
    'shelf',
    'shine',
    'ship',
    'shirt',
    'shoe',
    'shoot',
    'shop',
    'short',
    'should',
    'shoulder',
    'shout',
    'show',
    'sick',
    'side',
    'signal',
    'silence',
    'silly',
    'silver',
    'similar',
    'simple',
    'single',
    'since',
    'sing',
    'sink',
    'sister',
    'sit',
    'six',
    'size',
    'skill',
    'skin',
    'skirt',
    'sky',
    'sleep',
    'slip',
    'slow',
    'small',
    'smell',
    'smile',
    'smoke',
    'snow',
    'soap',
    'sock',
    'soft',
    'some',
    'someone',
    'something',
    'sometimes',
    'son',
    'soon',
    'sorry',
    'sound',
    'soup',
    'south',
    'space',
    'speak',
    'special',
    'speed',
    'spell',
    'spend',
    'spoon',
    'sport',
    'spread',
    'spring',
    'square',
    'stamp',
    'stand',
    'star',
    'start',
    'station',
    'stay',
    'steal',
    'steam',
    'step',
    'still',
    'stomach',
    'stone',
    'stop',
    'store',
    'storm',
    'story',
    'strange',
    'street',
    'strong',
    'structure',
    'student',
    'study',
    'stupid',
    'subject',
    'substance',
    'successful',
    'such',
    'sudden',
    'sugar',
    'suitable',
    'summer',
    'sun',
    'sunny',
    'support',
    'sure',
    'surprise',
    'sweet',
    'swim',
    'sword',
    'table',
    'take',
    'talk',
    'tall',
    'taste',
    'taxi',
    'tea',
    'teach',
    'team',
    'tear',
    'telephone',
    'television',
    'tell',
    'ten',
    'tennis',
    'terrible',
    'test',
    'than',
    'that',
    'the',
    'their',
    'theirs',
    'then',
    'there',
    'therefore',
    'these',
    'thick',
    'thin',
    'thing',
    'think',
    'third',
    'this',
    'those',
    'though',
    'threat',
    'three',
    'tidy',
    'tie',
    'title',
    'today',
    'toe',
    'together',
    'tomorrow',
    'tonight',
    'too',
    'tool',
    'tooth',
    'top',
    'total',
    'touch',
    'town',
    'train',
    'tram',
    'travel',
    'tree',
    'trouble',
    'true',
    'trust',
    'twice',
    'try',
    'turn',
    'type',
    'uncle',
    'under',
    'understand',
    'unit',
    'until',
    'use',
    'useful',
    'usual',
    'usually',
    'vegetable',
    'very',
    'village',
    'voice',
    'visit',
    'wait',
    'wake',
    'walk',
    'want',
    'warm',
    'wash',
    'waste',
    'watch',
    'water',
    'way',
    'weak',
    'wear',
    'weather',
    'wedding',
    'week',
    'weight',
    'welcome',
    'well',
    'west',
    'wet',
    'what',
    'wheel',
    'when',
    'where',
    'which',
    'while',
    'white',
    'who',
    'why',
    'wide',
    'wife',
    'wild',
    'will',
    'win',
    'wind',
    'window',
    'wine',
    'winter',
    'wire',
    'wise',
    'wish',
    'with',
    'without',
    'woman',
    'wonder',
    'word',
    'work',
    'world',
    'worry',
    'worst',
    'write',
    'wrong',
    'year',
    'yellow',
    'yes',
    'yesterday',
    'yet',
    'you',
    'young',
    'your',
    'yours',
    'zero',
    'zoo',
    'zoom'
    ];

    function capitalise (string) {
      return string.charAt(0).toUpperCase() + string.slice(1)
    }

    function getRandomEntry (items) {
      return items[Math.floor(Math.random() * items.length)]
    }

    /* src/Strike.svelte generated by Svelte v3.46.4 */
    const file$1 = "src/Strike.svelte";

    function create_fragment$1(ctx) {
    	let section;
    	let h1;
    	let t0;
    	let t1;
    	let t2;
    	let t3;
    	let p;
    	let t4;
    	let mounted;
    	let dispose;

    	const block = {
    		c: function create() {
    			section = element("section");
    			h1 = element("h1");
    			t0 = text("Operation... ");
    			t1 = text(/*strike_name*/ ctx[0]);
    			t2 = text("?");
    			t3 = space();
    			p = element("p");
    			t4 = text(/*strike_details*/ ctx[1]);
    			add_location(h1, file$1, 21, 2, 425);
    			add_location(p, file$1, 22, 2, 494);
    			add_location(section, file$1, 20, 0, 413);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, section, anchor);
    			append_dev(section, h1);
    			append_dev(h1, t0);
    			append_dev(h1, t1);
    			append_dev(h1, t2);
    			append_dev(section, t3);
    			append_dev(section, p);
    			append_dev(p, t4);

    			if (!mounted) {
    				dispose = [
    					listen_dev(h1, "click", /*generateStrikeName*/ ctx[2], false, false, false),
    					listen_dev(p, "click", /*generateStrikeDetails*/ ctx[3], false, false, false)
    				];

    				mounted = true;
    			}
    		},
    		p: function update(ctx, [dirty]) {
    			if (dirty & /*strike_name*/ 1) set_data_dev(t1, /*strike_name*/ ctx[0]);
    			if (dirty & /*strike_details*/ 2) set_data_dev(t4, /*strike_details*/ ctx[1]);
    		},
    		i: noop,
    		o: noop,
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(section);
    			mounted = false;
    			run_all(dispose);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment$1.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance$1($$self, $$props, $$invalidate) {
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('Strike', slots, []);
    	let strike_name = '';
    	let strike_details = '';

    	function generateStrikeName() {
    		$$invalidate(0, strike_name = capitalise(getRandomEntry(words)) + capitalise(getRandomEntry(words)));
    	}

    	function generateStrikeDetails() {
    		$$invalidate(1, strike_details = "...");
    	}

    	generateStrikeName();
    	generateStrikeDetails();
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<Strike> was created with unknown prop '${key}'`);
    	});

    	$$self.$capture_state = () => ({
    		words,
    		capitalise,
    		getRandomEntry,
    		strike_name,
    		strike_details,
    		generateStrikeName,
    		generateStrikeDetails
    	});

    	$$self.$inject_state = $$props => {
    		if ('strike_name' in $$props) $$invalidate(0, strike_name = $$props.strike_name);
    		if ('strike_details' in $$props) $$invalidate(1, strike_details = $$props.strike_details);
    	};

    	if ($$props && "$$inject" in $$props) {
    		$$self.$inject_state($$props.$$inject);
    	}

    	return [strike_name, strike_details, generateStrikeName, generateStrikeDetails];
    }

    class Strike extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance$1, create_fragment$1, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "Strike",
    			options,
    			id: create_fragment$1.name
    		});
    	}
    }

    /* src/App.svelte generated by Svelte v3.46.4 */
    const file = "src/App.svelte";

    function create_fragment(ctx) {
    	let main;
    	let strike;
    	let current;
    	strike = new Strike({ $$inline: true });

    	const block = {
    		c: function create() {
    			main = element("main");
    			create_component(strike.$$.fragment);
    			add_location(main, file, 4, 0, 60);
    		},
    		l: function claim(nodes) {
    			throw new Error("options.hydrate only works if the component was compiled with the `hydratable: true` option");
    		},
    		m: function mount(target, anchor) {
    			insert_dev(target, main, anchor);
    			mount_component(strike, main, null);
    			current = true;
    		},
    		p: noop,
    		i: function intro(local) {
    			if (current) return;
    			transition_in(strike.$$.fragment, local);
    			current = true;
    		},
    		o: function outro(local) {
    			transition_out(strike.$$.fragment, local);
    			current = false;
    		},
    		d: function destroy(detaching) {
    			if (detaching) detach_dev(main);
    			destroy_component(strike);
    		}
    	};

    	dispatch_dev("SvelteRegisterBlock", {
    		block,
    		id: create_fragment.name,
    		type: "component",
    		source: "",
    		ctx
    	});

    	return block;
    }

    function instance($$self, $$props, $$invalidate) {
    	let { $$slots: slots = {}, $$scope } = $$props;
    	validate_slots('App', slots, []);
    	const writable_props = [];

    	Object.keys($$props).forEach(key => {
    		if (!~writable_props.indexOf(key) && key.slice(0, 2) !== '$$' && key !== 'slot') console.warn(`<App> was created with unknown prop '${key}'`);
    	});

    	$$self.$capture_state = () => ({ Strike });
    	return [];
    }

    class App extends SvelteComponentDev {
    	constructor(options) {
    		super(options);
    		init(this, options, instance, create_fragment, safe_not_equal, {});

    		dispatch_dev("SvelteRegisterComponent", {
    			component: this,
    			tagName: "App",
    			options,
    			id: create_fragment.name
    		});
    	}
    }

    const app = new App({
      target: document.body
    });

    return app;

})();
