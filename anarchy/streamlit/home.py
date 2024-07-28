import streamlit as st
import pandas as pd 
import plotly.express as px
# from streamlit_option_menu import option_menu
from numerize.numerize import numerize

st.set_page_config(page_title='Dashboard', page_icon='🌍', layout='wide')
st.subheader('🔔 Insurance Descriptive Analytics')


df = pd.read_csv('data.csv')

st.sidebar.header('Please Filter')
region = st.sidebar.multiselect(
    'Select Region',
    options=df['Region'].unique(),
    default=df['Region'].unique()
)
location = st.sidebar.multiselect(
    'Select Location',
    options=df['Location'].unique(),
    default=df['Location'].unique()
)
construction = st.sidebar.multiselect(
    'Select Construction',
    options=df['Construction'].unique(),
    default=df['Construction'].unique()
)
df_selection = df.query(
    'Region==@region & Location==@location & Construction==@construction'
)


def home():

    with st.expander('Tabular'):
        show_data = st.multiselect('Filter: ', df_selection.columns, default=[])
        st.write(df_selection[show_data])

    investment_total = df_selection['Investment'].sum()
    investment_mode = df_selection['Investment'].mode()
    investment_mean = df_selection['Investment'].mean()
    investment_median = df_selection['Investment'].median()

    total, mean, median, mode = st.columns(4, gap='large')

    with total:
        st.info('Total Investment', icon='🤑')
        st.metric(label='sum TZS', value=f'{investment_total:,.0f}')
    
    with mean:
        st.info('Mean Investment', icon='🤑')
        st.metric(label='mean TZS', value=f'{investment_mean:,.0f}')

    with median:
        st.info('Median Investment', icon='🤑')
        st.metric(label='median TZS', value=f'{investment_median:,.0f}')
    
    with mode:
        st.info('Mode Investment', icon='🤑')
        st.metric(label='mode TZS', value=f'{investment_mode[0]:,.0f}')

    st.markdown('------')


def graphs():

    # simple line graph
    investment_by_business_type = (
        df_selection.groupby(by=['BusinessType']).count()[['Investment']].sort_values(by='Investment')
    )
    fig_investment = px.bar(
        investment_by_business_type,
        x='Investment',
        y=investment_by_business_type.index,
        orientation='h',
        title='<b> Investmeny by Business Type </b>',
        color_discrete_sequence=['#00b3b8']*len(investment_by_business_type),
        template='plotly_white'
    )

    fig_investment.update_layout(
        plot_bgcolor='rgb(0,0,0,0)',
        xaxis=(dict(showgrid=False))
    )

    # simple line graph
    investment_state = (df_selection.groupby(by=['State']).count()[['Investment']])
    fig_state = px.line(
        investment_state,
        x=investment_state.index,
        y='Investment',
        orientation='v',
        title='<b> Investmeny by State </b>',
        color_discrete_sequence=['#00b3b8']*len(investment_state),
        template='plotly_white'
    )
    fig_state.update_layout(
        plot_bgcolor='rgb(0,0,0,0)',
        xaxis=(dict(tickmode='linear')),
        yaxis=(dict(showgrid=False))
    )

    left, right = st.columns(2)
    left.plotly_chart(fig_state, use_container_width=True)
    right.plotly_chart(fig_investment, use_container_width=True)


home()
graphs()