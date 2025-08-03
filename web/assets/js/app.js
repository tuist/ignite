// Import CSS
import '../css/app.css'

import { createApp } from 'vue'
import { ApolloClient, InMemoryCache, split, createHttpLink } from '@apollo/client/core'
import { getMainDefinition } from '@apollo/client/utilities'
import gql from 'graphql-tag'
import App from './components/App.vue'

// Phoenix Socket imports
import { Socket as PhoenixSocket } from 'phoenix'
import * as AbsintheSocket from '@absinthe/socket'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'

// Apollo Client setup
const httpLink = createHttpLink({
  uri: '/api/graphql',
  credentials: 'same-origin'
})

// Create Phoenix Socket
const phoenixSocket = new PhoenixSocket('/socket', {
  params: () => {
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
    return { token }
  }
})

// Create Absinthe Socket
const absintheSocket = AbsintheSocket.create(phoenixSocket)

// Create Absinthe Socket Link
const wsLink = createAbsintheSocketLink(absintheSocket)

// Split traffic between websocket and http
const link = split(
  ({ query }) => {
    const definition = getMainDefinition(query)
    return (
      definition.kind === 'OperationDefinition' &&
      definition.operation === 'subscription'
    )
  },
  wsLink,
  httpLink
)

const apolloClient = new ApolloClient({
  link,
  cache: new InMemoryCache()
})

// Define GraphQL queries and subscriptions on App component
App.queries = {
  GET_PROJECTS: gql`
    query GetProjects {
      projects {
        id
        name
        path
        status
      }
    }
  `,
  GET_SIMULATORS: gql`
    query GetSimulators {
      simulators {
        id
        name
        deviceType
        runtime
        state
        isAvailable
      }
    }
  `
}

App.subscriptions = {
  PROJECT_UPDATED: gql`
    subscription ProjectUpdated {
      projectUpdated {
        id
        name
        path
        status
      }
    }
  `,
  BUILD_OUTPUT: gql`
    subscription BuildOutput($buildId: ID!) {
      buildOutput(buildId: $buildId) {
        buildId
        line
        timestamp
        type
      }
    }
  `
}

// Mount the app
const app = createApp(App, {
  apolloClient
})

// Import and use NuxtUI plugin
import ui from '@nuxt/ui/vue-plugin'

// Configure the plugin
app.use(ui)

app.mount('#app')