<template>
  <UApp>
    <div class="fixed inset-0 flex flex-col bg-gray-50">
    <!-- Navigation Bar -->
    <nav class="bg-white shadow-sm border-b border-gray-200 flex-shrink-0">
      <div class="px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center space-x-4">
            <h1 class="text-xl font-semibold text-gray-900">Ignite</h1>
            
            <!-- Project Dropdown -->
            <div class="relative">
              <USelectMenu
                v-model="currentProject"
                :options="projects"
                placeholder="Select a project"
                option-attribute="name"
                value-attribute="id"
                class="w-64"
              />
            </div>
          </div>
          
          <div class="flex items-center space-x-4">
            <!-- Connection Status -->
            <div class="flex items-center space-x-2">
              <div :class="[
                'w-2 h-2 rounded-full',
                sidekickConnected ? 'bg-green-500' : 'bg-red-500'
              ]"></div>
              <span class="text-sm text-gray-600">
                {{ sidekickConnected ? 'Connected' : 'Disconnected' }}
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
              message.type === 'user' ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-900'
            ]">
              <p>{{ message.content }}</p>
            </div>
          </div>
        </div>

        <!-- Input Area -->
        <div class="border-t border-gray-200 p-4">
          <form @submit.prevent="sendMessage" class="flex space-x-2">
            <UInput
              v-model="userInput"
              placeholder="Type your message..."
              class="flex-1"
              autocomplete="off"
            />
            <UButton type="submit" color="primary">
              Send
            </UButton>
          </form>
        </div>
      </div>

      <!-- Simulator View (Right) -->
      <div class="w-1/2 flex flex-col bg-gray-50">
        <div v-if="sidekickConnected">
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
              <UIcon name="i-heroicons-device-phone-mobile" class="mx-auto h-12 w-12 text-gray-400" />
              <p class="mt-4 text-lg font-medium">No destination active</p>
              <p class="mt-2">Select a destination to see it here</p>
            </div>
          </div>
        </div>
        
        <div v-else class="flex-1 flex items-center justify-center">
          <div class="text-center text-gray-500">
            <UIcon name="i-heroicons-signal-slash" class="mx-auto h-12 w-12 text-gray-400" />
            <p class="mt-4 text-lg font-medium">Not connected</p>
            <p class="mt-2">Connection required to use simulator and device features</p>
          </div>
        </div>
      </div>
    </div>
    </div>
  </UApp>
</template>

<script>
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
      sidekickConnected: false,
      messages: [],
      userInput: '',
      projects: [],
      currentProject: null,
      simulators: [],
      selectedDestination: null,
      destinationState: 'Shutdown',
      buildSubscription: null,
      projectSubscription: null
    }
  },
  computed: {
    simulatorOptions() {
      if (!this.simulators || this.simulators.length === 0) {
        return []
      }
      return this.simulators.map(sim => sim.name)
    }
  },
  async mounted() {
    await this.fetchProjects()
    await this.fetchSimulators()
    this.subscribeToProjectUpdates()
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
          query: this.$options.queries.GET_PROJECTS
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
          query: this.$options.queries.GET_SIMULATORS,
          fetchPolicy: 'network-only'
        })
        this.simulators = result.data.simulators || []
        this.sidekickConnected = true
      } catch (error) {
        console.error('Error fetching simulators:', error)
        this.sidekickConnected = false
      }
    },
    
    subscribeToProjectUpdates() {
      this.projectSubscription = this.apolloClient.subscribe({
        query: this.$options.subscriptions.PROJECT_UPDATED
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
  },
  queries: {
    GET_PROJECTS: /* GraphQL */ `
      query GetProjects {
        projects {
          id
          name
          path
          status
        }
      }
    `,
    GET_SIMULATORS: /* GraphQL */ `
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
  },
  subscriptions: {
    PROJECT_UPDATED: /* GraphQL */ `
      subscription ProjectUpdated {
        projectUpdated {
          id
          name
          path
          status
        }
      }
    `
  }
}
</script>