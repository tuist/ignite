<template>
  <div class="fixed inset-0 flex flex-col bg-gray-50">
    <!-- Navigation Bar -->
    <nav class="bg-white shadow-sm border-b border-gray-200 flex-shrink-0">
      <div class="px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <h1 class="text-xl font-semibold text-gray-900">🔥 Ignite</h1>
          </div>
          
          <div class="flex items-center space-x-4">
            <!-- Server URL -->
            <div v-if="daemonConnected && buildEnvironmentInfo" class="flex items-center space-x-2">
              <button
                @click="copyServerUrl"
                class="inline-flex items-center gap-1.5 px-2.5 py-1.5 text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500"
              >
                <svg v-if="!copied" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3" />
                </svg>
                <svg v-else class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                {{ serverUrl }}
              </button>
            </div>
            
            <!-- Connection Status -->
            <div class="flex items-center space-x-2">
              <div :class="[
                'w-2 h-2 rounded-full',
                daemonConnected ? 'bg-green-500' : 'bg-red-500'
              ]"></div>
              <span class="text-sm text-gray-600">
                {{ daemonConnected ? 'Connected' : 'Disconnected' }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <div class="flex flex-1 overflow-hidden">
      <!-- Chat Interface (Left) -->
      <div class="w-1/2 flex flex-col bg-white border-r border-gray-200">
        <!-- Messages -->
        <div class="flex-1 overflow-y-auto p-6 space-y-4">
          <div v-if="messages.length === 0" class="text-center text-gray-500 mt-8">
            <p class="text-lg font-medium">Welcome to Ignite!</p>
            <p class="mt-2">Start a conversation about developing for Apple platforms.</p>
          </div>
          
          <div
            v-for="message in messages"
            :key="message.id"
            :class="[
              'flex',
              message.type === 'user' ? 'justify-end' : 'justify-start'
            ]"
          >
            <div :class="[
              'max-w-[70%] rounded-lg px-4 py-2',
              message.type === 'user' ? 'bg-purple-600 text-white' : 'bg-gray-100 text-gray-900'
            ]">
              <p>{{ message.content }}</p>
            </div>
          </div>
        </div>

        <!-- Input Area -->
        <div class="border-t border-gray-200 p-4">
          <form @submit.prevent="sendMessage" class="flex space-x-2">
            <input
              v-model="userInput"
              placeholder="Type your message..."
              class="flex-1 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-purple-500 focus:border-purple-500"
              autocomplete="off"
            />
            <button
              type="submit"
              class="px-4 py-2 text-sm font-medium text-white bg-purple-600 hover:bg-purple-700 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500"
            >
              Send
            </button>
          </form>
        </div>
      </div>

      <!-- Simulator View (Right) -->
      <div class="w-1/2 flex flex-col bg-gray-50">
        <div v-if="daemonConnected">
          <!-- Simulator Controls -->
          <div class="bg-white border-b border-gray-200 p-4">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-4">
                <label class="text-sm font-medium text-gray-700">Simulator:</label>
                <select 
                  v-model="selectedDestination" 
                  class="min-w-80 px-3 py-2 border border-gray-300 rounded-md"
                  :disabled="simulators.length === 0"
                >
                  <option disabled selected value="">Select a simulator</option>
                  <option v-for="sim in simulators" :key="sim.id" :value="sim">
                    {{ sim.name }} ({{ sim.runtime }})
                  </option>
                </select>
              </div>

              <div v-if="selectedDestination && selectedDestination.type === 'simulator'" class="flex items-center space-x-2">
                <UBadge
                  :color="destinationState === 'Booted' ? 'green' : 'gray'"
                  size="sm"
                >
                  {{ destinationState }}
                </UBadge>
                
                <UButton
                  v-if="destinationState === 'Shutdown'"
                  @click="bootDestination"
                  color="green"
                  size="sm"
                >
                  Boot
                </UButton>
                
                <UButton
                  v-if="destinationState === 'Booted'"
                  @click="shutdownDestination"
                  color="red"
                  size="sm"
                >
                  Shutdown
                </UButton>
              </div>
              
              <div v-if="selectedDestination && selectedDestination.type === 'device'" class="flex items-center space-x-2">
                <UBadge
                  :color="destinationState === 'Connected' ? 'green' : 'gray'"
                  size="sm"
                >
                  {{ destinationState }}
                </UBadge>
              </div>
            </div>
          </div>

          <!-- Simulator Display Area -->
          <div class="flex-1 flex items-center justify-center p-8">
            <div v-if="selectedDestination && selectedDestination.type === 'simulator' && destinationState === 'Booted'" class="bg-white rounded-lg shadow-lg p-8">
              <div class="text-center">
                <div class="w-64 h-96 bg-gray-900 rounded-lg flex items-center justify-center">
                  <p class="text-white">Simulator Display</p>
                </div>
                <p class="mt-4 text-sm text-gray-600">
                  {{ selectedDestination.name }} is running
                </p>
              </div>
            </div>
            
            <div v-else-if="selectedDestination && selectedDestination.type === 'device' && destinationState === 'Connected'" class="bg-white rounded-lg shadow-lg p-8">
              <div class="text-center">
                <div class="w-64 h-96 bg-gray-900 rounded-lg flex items-center justify-center">
                  <p class="text-white">Device: {{ selectedDestination.name }}</p>
                </div>
                <p class="mt-4 text-sm text-gray-600">
                  {{ selectedDestination.deviceType }} - {{ selectedDestination.runtime }}
                </p>
              </div>
            </div>
            
            <div v-else class="text-center text-gray-500">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
            </svg>
              <p class="mt-4 text-lg font-medium">No destination active</p>
              <p class="mt-2">Select a destination to see it here</p>
            </div>
          </div>
        </div>
        
        <div v-else class="flex-1 flex items-center justify-center">
          <div class="text-center text-gray-500">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636a9 9 0 010 12.728m0 0l-2.829-2.829m2.829 2.829L21 21M15.536 8.464a5 5 0 010 7.072m0 0l-2.829-2.829m-4.243 2.829a4.978 4.978 0 01-1.414-2.83m-1.414 5.658a9 9 0 01-2.167-9.238m7.824 2.167a1 1 0 111.414 1.414m-1.414-1.414L3 3m8.293 8.293l1.414 1.414" />
            </svg>
            <p class="mt-4 text-lg font-medium">Not connected</p>
            <p class="mt-2">Connection required to use simulator and device features</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import gql from 'graphql-tag'

const GET_PROJECTS = gql`
  query GetProjects {
    projects {
      id
      name
      path
      status
    }
  }
`

const GET_SIMULATORS = gql`
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

const GET_BUILD_ENVIRONMENT_INFO = gql`
  query GetBuildEnvironmentInfo {
    buildEnvironmentInfo {
      localIp
      tailscaleUrl
    }
  }
`

const PROJECT_UPDATED = gql`
  subscription ProjectUpdated {
    projectUpdated {
      id
      name
      path
      status
    }
  }
`

export default {
  name: 'App',
  props: {
    apolloClient: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      daemonConnected: false,
      messages: [],
      userInput: '',
      projects: [],
      currentProject: null,
      simulators: [],
      selectedDestination: null,
      destinationState: 'Shutdown',
      buildSubscription: null,
      projectSubscription: null,
      buildEnvironmentInfo: null,
      copied: false
    }
  },
  computed: {
    simulatorOptions() {
      if (!this.simulators || this.simulators.length === 0) {
        return []
      }
      return this.simulators.map(sim => sim.name)
    },
    serverUrl() {
      if (!this.buildEnvironmentInfo) return ''
      
      if (this.buildEnvironmentInfo.tailscaleUrl) {
        return this.buildEnvironmentInfo.tailscaleUrl
      }
      
      return this.buildEnvironmentInfo.localIp
    }
  },
  async mounted() {
    await this.fetchProjects()
    await this.fetchSimulators()
    await this.fetchBuildEnvironmentInfo()
    this.subscribeToProjectUpdates()
  },
  watch: {
    daemonConnected(newVal) {
      if (newVal) {
        // When sidekick connects, fetch build environment info
        this.fetchBuildEnvironmentInfo()
      }
    }
  },
  beforeUnmount() {
    if (this.buildSubscription) {
      this.buildSubscription.unsubscribe()
    }
    if (this.projectSubscription) {
      this.projectSubscription.unsubscribe()
    }
  },
  methods: {
    async fetchProjects() {
      try {
        const result = await this.apolloClient.query({
          query: GET_PROJECTS
        })
        this.projects = result.data.projects || []
        if (this.projects.length > 0 && !this.currentProject) {
          this.currentProject = this.projects[0]
        }
      } catch (error) {
        console.error('Error fetching projects:', error)
      }
    },
    
    async fetchSimulators() {
      try {
        const result = await this.apolloClient.query({
          query: GET_SIMULATORS,
          fetchPolicy: 'network-only'
        })
        this.simulators = result.data.simulators || []
        this.daemonConnected = true
      } catch (error) {
        console.error('Error fetching simulators:', error)
        this.daemonConnected = false
      }
    },
    
    async fetchBuildEnvironmentInfo() {
      try {
        const result = await this.apolloClient.query({
          query: GET_BUILD_ENVIRONMENT_INFO,
          fetchPolicy: 'network-only'
        })
        this.buildEnvironmentInfo = result.data.buildEnvironmentInfo
      } catch (error) {
        console.error('Error fetching build environment info:', error)
      }
    },
    
    async copyServerUrl() {
      if (!this.serverUrl) return
      
      try {
        await navigator.clipboard.writeText(this.serverUrl)
        this.copied = true
        setTimeout(() => {
          this.copied = false
        }, 2000)
      } catch (error) {
        console.error('Failed to copy URL:', error)
      }
    },
    
    subscribeToProjectUpdates() {
      this.projectSubscription = this.apolloClient.subscribe({
        query: PROJECT_UPDATED
      }).subscribe({
        next: ({ data }) => {
          if (data.projectUpdated) {
            this.fetchProjects()
          }
        },
        error: (err) => console.error('Subscription error:', err)
      })
    },
    
    sendMessage() {
      if (this.userInput.trim() === '') return
      
      const userMessage = {
        id: Date.now(),
        type: 'user',
        content: this.userInput,
        timestamp: new Date()
      }
      
      const assistantMessage = {
        id: Date.now() + 1,
        type: 'assistant',
        content: `I received your message: '${this.userInput}'. I'm here to help you develop for Apple platforms!`,
        timestamp: new Date()
      }
      
      this.messages.push(userMessage, assistantMessage)
      this.userInput = ''
    },
    
    bootDestination() {
      if (!this.selectedDestination) return
      
      this.destinationState = 'Booting'
      
      // Simulate booting
      setTimeout(() => {
        this.destinationState = 'Booted'
      }, 3000)
    },
    
    shutdownDestination() {
      if (!this.selectedDestination) return
      
      this.destinationState = 'ShuttingDown'
      
      // Simulate shutdown
      setTimeout(() => {
        this.destinationState = 'Shutdown'
      }, 1000)
    }
  }
}
</script>